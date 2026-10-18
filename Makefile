.PHONY: build watch

build:
	typst compile cv.typ CV_KARTKAYA.pdf --font-path fonts/

watch:
	typst watch cv.typ CV_KARTKAYA.pdf --font-path fonts/
