<script>
  window.MathJax = {
  tex: {
    macros: {
      Xmatrix:
        "\\begin{bmatrix}" +
        "1 & X_{11} & X_{12} & \\cdots & X_{1k} \\\\" +
        "1 & X_{21} & X_{22} & \\cdots & X_{2k} \\\\" +
        "\\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\" +
        "1 & X_{n1} & X_{n2} & \\cdots & X_{nk}" +
        "\\end{bmatrix}",

      Xonematrix:
        "\\begin{bmatrix}" +
        "1 & X_{11} \\\\" +
        "1 & X_{21} \\\\" +
        "\\vdots \\\\" +
        "1 & X_{n1}" +
        "\\end{bmatrix}",

      Ymatrix:
        "\\begin{bmatrix}Y_1 \\\\ Y_2 \\\\ \\vdots \\\\ Y_n\\end{bmatrix}",

      betamatrix:
        "\\begin{bmatrix}\\beta_0 \\\\ \\beta_1 \\\\ \\vdots \\\\ \\beta_k\\end{bmatrix}",

      betaonematrix:
        "\\begin{bmatrix}\\beta_0 \\\\ \\beta_1\\end{bmatrix}",

      Ematrix:
        "\\begin{bmatrix}E_1 \\\\ E_2 \\\\ \\vdots \\\\ E_n\\end{bmatrix}",

      Sum: ["\\sum_{i=1}^{#1}", 1]
    }
  }
};
</script>