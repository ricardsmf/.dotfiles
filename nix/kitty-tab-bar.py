# Custom draw_tab for kitty's vertical (tab_bar_edge left) tab bar, loaded
# because tab_bar_style = custom. Linked to ~/.config/kitty/tab_bar.py by
# nix/kitty.nix. Colors come from the active theme, so a themeFile change
# needs no edits here.
import inspect
import textwrap

import kitty.tab_bar as tb
from kitty.fast_data_types import Screen, get_options
from kitty.rgb import alpha_blend
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int


# kitty 0.49 leaves a blank line between vertical tabs while there is room,
# via a hardcoded `spacing = 1` with no option to turn it off. Recompile
# update_vertical with 0 instead; if a kitty update changes that line, the
# patch is skipped and the gap simply comes back.
def _pack_vertical_tabs() -> None:
    fn = tb.TabBar.update_vertical
    if getattr(fn, '_packed', False):
        return
    src = textwrap.dedent(inspect.getsource(fn))
    if src.count('spacing = 1\n') != 1:
        return
    ns: dict = {}
    exec(compile(src.replace('spacing = 1\n', 'spacing = 0\n'), tb.__file__, 'exec'), vars(tb), ns)
    ns['update_vertical']._packed = True
    tb.TabBar.update_vertical = ns['update_vertical']


_pack_vertical_tabs()


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    opts = get_options()
    muted = alpha_blend(draw_data.inactive_fg, draw_data.default_bg, 0.5)
    # the title template's {fmt.fg.tab} resolves against draw_data, so the
    # muted color has to live there too, not just on the cursor
    draw_data = draw_data._replace(inactive_fg=muted, inactive_bg=draw_data.default_bg)
    sidebar_bg = as_rgb(color_as_int(draw_data.default_bg))
    muted_fg = as_rgb(color_as_int(muted))
    # kitty appends the new-tab button as a pseudo-tab titled "+"
    is_button = is_last and tab.title == '+' and not tab.tab_id

    if tab.is_active and not is_button:
        row_bg = screen.cursor.bg
        screen.cursor.fg = as_rgb(color_as_int(opts.color4))
        screen.draw('▎')
        screen.cursor.fg = as_rgb(color_as_int(draw_data.active_fg))
    else:
        row_bg = sidebar_bg
        screen.cursor.bg = row_bg
        screen.cursor.fg = muted_fg
        screen.draw(' ')
    screen.draw(' ')

    limit = screen.columns - 1
    draw_title(draw_data, screen, tab, index, limit - screen.cursor.x)
    if screen.cursor.x >= limit:
        screen.cursor.x = limit - 1
        screen.draw('…')

    screen.cursor.bg = row_bg
    screen.draw(' ' * (screen.columns - screen.cursor.x))
    end = screen.cursor.x
    screen.cursor.bg = 0
    screen.cursor.bold = screen.cursor.italic = False
    return end
