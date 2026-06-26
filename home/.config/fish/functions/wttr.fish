# Fetch a weather report from wttr.in (default: Mem Martins, one-line format).
function wttr -d "Show the weather from wttr.in"
  argparse 'h/help' 'F/full' 'm/moon' 'u/units=' 'l/lang=' 'f/format=' -- $argv
  or return 1

  if set -q _flag_help
    set -l cmd (status current-function)
    echo "Usage: $cmd [options] [location]"
    echo
    echo "Defaults to Mem Martins in one-line format."
    echo
    echo "Options:"
    echo "  -F, --full         Full multi-day report instead of one line"
    echo "  -m, --moon         Show the moon phase instead of weather"
    echo "  -u, --units UNIT   m (metric), u (USCS), or M (m/s wind)"
    echo "  -l, --lang LANG    Language code, e.g. en, pt, de"
    echo "  -f, --format FMT   Custom wttr.in format string"
    echo "  -h, --help         Show this help"
    echo
    echo "Examples:"
    echo "  $cmd                 # one-line weather for Mem Martins"
    echo "  $cmd Lisbon          # one-line weather for Lisbon"
    echo "  $cmd -F Porto        # full report for Porto"
    echo "  $cmd -m              # moon phase"
    return 0
  end

  set -l location (string join '+' $argv)
  if test -z "$location"
    set location Mem+Martins
  end
  if set -q _flag_moon
    set location moon
  end

  set -l query
  if set -q _flag_format
    set -a query "format=$_flag_format"
  else if not set -q _flag_full
    set -a query "format=%l:+%c+%t,+%p,+%w"
  end
  if set -q _flag_units
    set -a query "$_flag_units"
  end
  if set -q _flag_lang
    set -a query "lang=$_flag_lang"
  end

  set -l url "https://wttr.in/$location"
  if test (count $query) -gt 0
    set url "$url?"(string join '&' $query)
  end

  echo (curl -fsSL -H "Accept-Language: $LANG" "$url" | string collect)
end
