TEXSRCS=$(wildcard *.tex)
TEXSUBS=$(wildcard */*.tex)
TEXPDFS=$(TEXSRCS:.tex=.pdf)

SVGSRCS=$(wildcard */*.svg)
SVGIMGS=$(SVGSRCS:.svg=.pdf)

XCFSRCS=$(wildcard */*.xcf)
XCFIMGS=$(XCFSRCS:.xcf=.png)

TSVSRCS=$(wildcard */*.tsv)
PLTSRCS=$(wildcard */*.plt)
PLTIMGS=$(PLTSRCS:.plt=.pdf)

PNGIMGS=$(wildcard */*.png)

all: $(TEXPDFS)

$(TEXPDFS): %.pdf: %.tex $(TEXSUBS) $(SVGIMGS) $(XCFIMGS) $(PLTIMGS) $(PNGIMGS)
	xelatex $<
	xelatex $<
	pdftk $@ cat 2-end 1 output $*.tmp
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$@ $*.tmp
	rm $*.tmp

$(PLTIMGS): %.pdf: %.plt %.tsv
	gnuplot $<

$(SVGIMGS): %.pdf: %.svg
	rsvg-convert -f pdf $< -o $@

$(XCFIMGS): %.png: %.xcf
	xcf2png $< > $@

clean:
	rm -f *.log *.toc *.bbl *.blg *.aux *.out *.nav *.snm */*.aux *.loe *.loa *.lof *.lot *.toc *.thm *.maf *.mtc* *.tmp

mrproper: clean
	rm -f $(TEXPDFS) $(SVGIMGS) $(XCFIMGS) $(PLTIMGS)
