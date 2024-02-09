import parseopt
import parseutils
import streams
import os

import vimes/load
import bench
include debug_mem

let VERSION = "0.2.1"

type Cfg = object
    input_path: string
    format: string
    benchmark: int
    debug: bool
    trace: bool

proc print_help() =
    echo "Usage: " & get_app_filename() & " [options] input_file"
    echo "Options:"
    echo "  -d        dump debug info"
    echo "  -t        trace execution"
    echo "  -b <n>    benchmark mode, run <n> times"
    #echo "  -f <fmt>  input format: hex | b10 | b16"
    echo "  -h        print this help"
    echo "  -help     print this help"
    echo "  -v        print version"


proc get_cli_config() : Cfg = 
    result.format = "b10"
    #
    let params = command_line_params()
    var p = init_opt_parser(params)
    while true:
        p.next()
        case p.kind
            of cmdEnd: break
            of cmdShortOption, cmdLongOption:
                case p.key:
                    of "d":
                        result.debug = true
                    of "b":
                        var vi : int
                        if parse_int(p.val, vi) > 0:
                            result.benchmark = vi
                    # of "f":
                    #     if p.val notin @["hex", "b10", "b16"]:
                    #         quit("ERROR: unknown format '" & p.val & "'", 1)
                    #     result.format = p.val
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
    var bench = new_bench()
    let text = read_file(cfg.input_path)
    case cfg.format:
        of "hex":
            code = code_from_hex[Word](text)
        of "b10":
            code = code_from_num[Word](text, base=10)
        of "b16":
            code = code_from_num[Word](text, base=16)
    if cfg.benchmark > 0:
        for i in 1..cfg.benchmark:
            reset(quick=true)
            run()
            bench.done(cc)
        bench.show(item="cycle")
    else:
        reset(quick=true)
        run()
    if cfg.debug:
        debug_mem()
        debug()
