import os
import sys

EX = (".png", ".jpg", ".eps")
CONVERT = "convert -density"
DENSITY = "1200"


def convert_to_pdf_all():
    """
    convert ex in EX to pdf file
    :return:
    """

    # set density if given
    argvs = sys.argv
    density = DENSITY
    if len(argvs) == 2:
        density = argvs[1]
    # convert file to pdf for all extensions
    for filename in os.listdir('.'):
        f_name = filename[:-4]
        ex = filename[-4:].lower()
        if ex in EX :
            cmd = CONVERT + " " + density + " \"" + filename + "\" \"" + f_name + ".pdf" + "\""
            print(cmd)
            os.system(cmd)


if __name__ == "__main__":
    convert_to_pdf_all()
