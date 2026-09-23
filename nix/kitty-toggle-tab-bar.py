# Kitten bound in nix/kitty.nix. kitty has no toggle action for the tab bar,
# but a config reload re-reads tab_bar_style, so hiding is a reload with a
# `tab_bar_style hidden` override. Showing also overrides tab_bar_min_tabs to
# 1, otherwise kitty's default of 2 keeps the bar hidden with a single tab.
from kittens.tui.handler import result_handler
from kitty.fast_data_types import get_options

OWNED = ('tab_bar_style', 'tab_bar_min_tabs')


def main(args: list[str]) -> None:
    pass


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: None, target_window_id: int, boss) -> None:
    tm = boss.active_tab_manager
    shown = tm is not None and not tm.tab_bar_hidden and tm.tab_bar_should_be_visible
    overrides = tuple(o for o in get_options().config_overrides if not o.startswith(OWNED))
    overrides += ('tab_bar_style hidden',) if shown else ('tab_bar_min_tabs 1',)
    boss.load_config_file(apply_overrides=False, overrides=overrides)
    # A reload lays out the bar but not the windows, so a returning bar would
    # be drawn over them without this.
    for tm in boss.all_tab_managers:
        tm.resize()
