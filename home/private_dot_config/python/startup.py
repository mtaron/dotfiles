import atexit
import os
import sys

HOME = os.path.expanduser("~")
XDG_DATA_HOME = os.environ['XDG_DATA_HOME'] \
                    if os.environ['XDG_DATA_HOME'] \
                    else os.path.join(HOME, ".local", "share")
PYTHON_DATA = os.path.join(XDG_DATA_HOME, "python")


def interactivehook():
    try:
        import readline
    except ImportError:
        return

    readline.parse_and_bind('tab: complete')

    if not os.path.isdir(PYTHON_DATA):
        os.mkdir(PYTHON_DATA)
    histfile = os.path.join(PYTHON_DATA, "history")

    try:
        readline.read_history_file(histfile)
        readline.set_history_length(1000)
    except FileNotFoundError:
        pass

    atexit.register(readline.write_history_file, histfile)


sys.__interactivehook__ = interactivehook
