MAIN=article

all: $(MAIN).pdf

$(MAIN).pdf: $(wildcard *.tex) $(wildcard *.tikz)
	pdflatex $(LATEXFLAGS) $(MAIN)
	pdflatex $(LATEXFLAGS) $(MAIN)
	bibtex $(MAIN)
	bibtex $(MAIN)
	pdflatex $(LATEXFLAGS) $(MAIN)
	pdflatex $(LATEXFLAGS) $(MAIN)

clean:
	$(RM) *.aux *.log $(MAIN).dvi $(MAIN).ps $(MAIN).pdf $(MAIN).bbl $(MAIN).blg $(MAIN).synctex.gz *~

findref:
	@echo
	@test \
          `grep -c undefined $(MAIN).log | grep -v There | sed 's/.*\`//g' | sed "s/'.*//g"` = "0" \
            && echo "No undefined references" \
            || echo Finding undefined references ; \
               for uref in `grep undefined $(MAIN).log | grep -v There | sed 's/.*\`//g' | sed "s/'.*//g"`; \
               do  \
                echo "--> $$uref ";\
                grep -n "[rc][ei].*$$uref" *.tex | grep -v '.tex:[0-9]*:%' | sed 's/:/ -- Line /' | sed 's/:/:  /';\
                echo ;\
               done

.PHONY: clean

