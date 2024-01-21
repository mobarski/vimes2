import parseopt
import parseutils
import streams
import os

let VERSION = "0.1.0"

type Cfg = object
    input_path: string
    format: string
    benchmark: int

proc print_help() =
    echo "Usage: " & get_app_filename() & " [options] [input_file]"
    echo "Options:"
    echo "  -b <n>    benchmark mode, run <n> times"
    echo "  -f <fmt>  input format, one of: hex, bin, b10, b16"
    echo "  -h        print this help"
    echo "  -help     print this help"
    echo "  -v        print version"

proc get_cli_config() : Cfg = 
    result.format = "hex"
    #
    let params = command_line_params()
    var p = init_opt_parser(params)
    while true:
        p.next()
        case p.kind
            of cmdEnd: break
            of cmdShortOption, cmdLongOption:
                case p.key:
                    of "b":
                        var vi : int
                        if parse_int(p.val, vi) > 0:
                            result.benchmark = vi
                    of "f":
                        if p.val notin @["hex", "bin", "b10", "b16"]:
                            quit("ERROR: unknown format '" & p.val & "'", 1)
                        result.format = p.val
                    of "v":
                        echo VERSION
                        quit("", 0)
                    of "h", "help":
                        print_help()
                        quit("", 0)
                    else: quit("ERROR: unknown CLI option '" & p.key & "'", 1)
            of cmdArgument:
                result.input_path = p.key
    if result.input_path.len == 0:
        print_help()
        quit("ERROR: input file not specified", 1)

proc cli() =
    let cfg = get_cli_config()
    if cfg.format=="hex":
        let text = read_file(cfg.input_path)
        let code = code_from_hex(text)
        echo code # XXX
