# Mermaid Diagrams

Why have a separate folder for mermaid diagrams when Quarto natively supports them? Unfortunately, there were some technical issues encountered in attempting to include at least one mermaid diagram:

1. There is a known bug that .svg outputs (the preferred format) conflict with tabset panels when the mermaid diagram is not in the first panel. Also in .svg outputs, boxes of text with multiple lines almost always have all of the text clipped/disappeared.
2. A potential solution to this is to change the output to .png which is what we initially did.
3. However, subsequent runs of our GH Action pipeline stall when trying to generate the png output. I'm not 100% certain that this is not just a transient problem with GitHub, but at this point, simply creating the mermaid diagram as an .svg locally seems to be a better solution.
4. Mermaid is essentially no longer supported/usable on Macs which is good half of our team.

So the solution for now is to store the original Mermaid code in this folder, generate somewhere else like the Mermaid generator website, and then place the output file here i.e. `/assets/diagrams/*`