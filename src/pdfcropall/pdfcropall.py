import os

PDFCROP = "tcpdfcrop"
PDF = ".pdf"


def main():
    for filename in os.listdir('.'):
        if PDF in filename.lower():
            f_name = filename[:-4]
            if "-crop" in f_name:
                continue
            cmd = PDFCROP + " " + f_name
            print(cmd)
            os.system(cmd)


if __name__ == "__main__":
    main()
