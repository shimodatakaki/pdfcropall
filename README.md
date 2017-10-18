# pdfcropall

## Synopsis

pdfcropall はカレントディレクトリ内の全pdfまたはPDFファイルをcropします。


## Usage
1.pdfcropall.exe と tcpdfcrop.bat のパスを通す([http://realize.jounin.jp/path.html](http://realize.jounin.jp/path.html))。

2.以下をcropしたいpdfファイルが複数あるディレクトリで以下コマンドライン実行。

    pdfcropall

----------------------------------------

# img2pdfall

## Synopsis

img2pdfall はカレントディレクトリ内の全jpg, png, epsまたはJPG, PNG, EPSファイルをpdfに変換します。


## Usage
1.jpeg2pdfall.exe と jpeg2pdf.exe のパスを通す。

2.以下をpdfに変換したいjpg, png, epsファイルが複数あるディレクトリで以下コマンドライン実行。

    img2pdfall

##Options

pdfファイルへの変換densityは引数で指定することが可能(デフォルトで1200)

	#if you want 600 density pdf file
	img2pdfall 600 