"""
Monta as figuras do Ex. 2 a partir dos gráficos já salvos no notebook "Q2 .ipynb".

Como rodar (na pasta Ex2_latex):
    python montar_figuras.py

Requer: pip install pillow

O que o script faz:
  1. lê o notebook (que está na pasta de cima, "Lista 3/");
  2. extrai cada gráfico para imagens_extraidas/c<célula>_<k>.png
     (célula = posição da célula no notebook, começando em 0;
      k = número do gráfico dentro da célula, pois uma célula pode gerar mais de um);
  3. junta os gráficos em painéis e salva ex2_descritiva.png, ex2_diag.png e ex2_gamlss.png.

Para personalizar, mexa só na seção "CONFIGURAÇÃO" lá embaixo.
"""

import base64
import json
from pathlib import Path

from PIL import Image

PASTA = Path(__file__).resolve().parent          # pasta deste script (Ex2_latex)
NOTEBOOK = PASTA.parent / "Q2 .ipynb"             # o notebook fica em "Lista 3/"
EXTRAIDAS = PASTA / "imagens_extraidas"


# ----------------------------------------------------------------------
# 1) Extrair os PNGs do notebook
# ----------------------------------------------------------------------
def extrair_imagens(notebook, destino):
    """Salva cada gráfico do notebook como c<célula>_<k>.png e lista o que achou."""
    destino.mkdir(exist_ok=True)
    nb = json.loads(notebook.read_text(encoding="utf-8"))
    print(f"Imagens encontradas em {notebook.name}:")
    for i, cel in enumerate(nb["cells"]):
        k = 0
        for out in cel.get("outputs", []):
            dados = out.get("data", {})
            if "image/png" in dados:
                nome = f"c{i}_{k}"
                (destino / f"{nome}.png").write_bytes(base64.b64decode(dados["image/png"]))
                # primeira linha do código da célula, para você saber de qual gráfico se trata
                codigo = "".join(cel["source"]).strip().splitlines()
                print(f"  {nome:8s} <- {codigo[0][:60] if codigo else ''}")
                k += 1


# ----------------------------------------------------------------------
# 2) Juntar imagens em grid
# ----------------------------------------------------------------------
def grid(nomes, saida, ncol=2, espaco=20, fundo="white", tamanho=None):
    """
    nomes   : lista de imagens (sem .png) de imagens_extraidas/, na ordem de leitura
    saida   : arquivo final
    ncol    : número de colunas (len(nomes) colunas = tudo numa linha)
    espaco  : pixels entre os gráficos
    fundo   : cor do fundo/espaço
    tamanho : (largura, altura) para padronizar cada gráfico; None mantém o original
    """
    ims = [Image.open(EXTRAIDAS / f"{n}.png").convert("RGB") for n in nomes]
    if tamanho:
        ims = [im.resize(tamanho) for im in ims]

    w = max(im.size[0] for im in ims)             # tamanho de cada "célula" do grid
    h = max(im.size[1] for im in ims)
    nlin = -(-len(ims) // ncol)                   # divisão arredondando para cima

    painel = Image.new("RGB", (ncol * w + (ncol - 1) * espaco,
                               nlin * h + (nlin - 1) * espaco), fundo)
    for k, im in enumerate(ims):
        lin, col = divmod(k, ncol)                # posição k -> (linha, coluna)
        painel.paste(im, (col * (w + espaco), lin * (h + espaco)))

    painel.save(PASTA / saida, dpi=(300, 300))
    print(f"Salvo: {saida}  ({nlin}x{ncol}, {painel.size[0]}x{painel.size[1]} px)")


# ----------------------------------------------------------------------
# CONFIGURAÇÃO
# ----------------------------------------------------------------------
if __name__ == "__main__":
    extrair_imagens(NOTEBOOK, EXTRAIDAS)
    print()

    # Descritiva: histograma + dispersão (1 linha, 2 colunas)
    grid(["c4_0", "c5_0"], "ex2_descritiva.png", ncol=2)

    # Diagnóstico: alavanca, resíduo deviance, Cook, envelope
    #   ncol=4 -> tudo numa linha (como está no .tex) | ncol=2 -> grid 2x2
    grid(["c12_0", "c13_0", "c15_0", "c16_0"], "ex2_diag.png", ncol=2)

    # GAMLSS: plot(), wp(), term.plot de lwbc e de AG
    #   (o term.plot gera 2 gráficos na mesma célula: c27_0 e c27_1)
    grid(["c23_0", "c25_0", "c27_0", "c27_1"], "ex2_gamlss.png", ncol=2)

    # Se trocar a ordem das células no notebook, os números mudam:
    # veja a lista impressa no começo e ajuste os nomes acima.
