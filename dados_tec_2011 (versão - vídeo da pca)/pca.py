import os
import numpy as np
from matplotlib import pyplot as plt
import matplotlib as mpl
mpl.rc('font', size=14)

# Dicionário com as coordenadas (latitude, longitude) das estações na ordem alfabética fornecida
estacoes_coords = [
    (-9.749, -36.653),   # ALAR
    (-11.306, -41.859),  # BAIR
    (-17.555, -39.743),  # BATF
    (-14.888, -40.803),  # BAVC
    (-1.409, -48.463),   # BELE
    (2.845, -60.701),    # BOAV
    (-15.947, -47.878),  # BRAZ
    (-3.877, -38.426),   # BRFT
    (-3.878, -38.426),   # CEEU
    (-20.311, -40.319),  # CEFE
    (-3.711, -38.473),   # CEFT
    (-22.687, -44.985),  # CHPI
    (-15.555, -56.07),   # CUIB
    (-17.883, -51.726),  # GOJA
    (-20.428, -51.343),  # ILHA
    (-28.235, -48.656),  # IMBT
    (-5.492, -47.497),   # IMPZ
    (-5.362, -49.122),   # MABA
    (-19.942, -43.925),  # MGBH
    (-22.319, -46.328),  # MGIN
    (-16.716, -43.858),  # MGMC
    (-19.21, -46.133),   # MGRP
    (-18.919, -48.256),  # MGUB
    (-20.441, -54.541),  # MSCG
    (-13.556, -52.271),  # MTCN
    (-10.804, -55.456),  # MTCO
    (-11.619, -50.664),  # MTSF
    (-12.545, -55.727),  # MTSR
    (-3.023, -60.055),   # NAUS
    (-25.02, -47.925),   # NEIA
    (-22.896, -43.224),  # ONRJ
    (-4.288, -56.036),   # PAIT
    (-7.214, -35.907),   # PBCG
    (-9.384, -40.506),   # PEPE
    (-9.031, -42.703),   # PISR
    (-5.102, -42.793),   # PITN
    (-30.074, -51.12),   # POAL
    (-22.318, -44.327),  # POLI
    (-8.709, -63.896),   # POVE
    (-22.12, -51.409),   # PPTE
    (-25.384, -51.488),  # PRGU
    (-23.41, -51.938),   # PRMA
    (-9.965, -67.803),   # RIOB
    (-22.818, -43.306),  # RIOD
    (-21.765, -41.326),  # RJCG
    (-5.204, -37.325),   # RMNO
    (-5.836, -35.208),   # RNNA
    (-13.122, -60.544),  # ROCD
    (-10.784, -65.331),  # ROGM
    (-10.864, -61.96),   # ROJI
    (-22.523, -52.952),  # ROSA
    (-0.144, -67.058),   # SAGA
    (-12.975, -38.516),  # SALU
    (-12.939, -38.432),  # SAVO
    (-27.138, -52.6),    # SCCH
    (-27.793, -50.304),  # SCLA
    (-20.786, -49.36),   # SJRP
    (-29.719, -53.717),  # SMAR
    (-21.185, -50.44),   # SPAR
    (-12.975, -38.516),  # SSA1
    (-11.747, -49.049),  # TOGU
    (-10.171, -48.331),  # TOPL
    (-25.448, -49.231),  # UFPR
    (-20.762, -42.87),   # VICO
]

# -------------------------
# 1) Carregar matriz dos arquivos txt
# -------------------------
folder_path = r"C:\Users\vikla\Downloads\dados_tec_2011\formatado"
file_list = sorted([f for f in os.listdir(folder_path) if f.endswith(".txt")])

matrix_list = []
for file_name in file_list:
    file_path = os.path.join(folder_path, file_name)
    data = np.loadtxt(file_path)
    matrix_list.append(data)

# -------------------------
# 2) Criar a matriz de dados, mantendo as estações como colunas e tempos como linhas
# Não é necessário transpor neste passo, já que queremos manter as estações como colunas
matrix_diffTEC = np.column_stack(matrix_list)
print("Shape da matriz carregada (sem transposição):", matrix_diffTEC.shape)  # Exemplo de shape: (44640, 64)

# -------------------------
# 3) Calcular anomalia e preencher NaNs
# -------------------------
X_anom = matrix_diffTEC - np.nanmean(matrix_diffTEC, axis=0)
X_anom_filled = np.nan_to_num(X_anom, nan=0.0)

# -------------------------
# 4) Padronizar
# -------------------------
a = (X_anom_filled - X_anom_filled.mean()) / X_anom_filled.std()
print(a.mean(), a.std())  # deve dar ~0 e 1

Nt, N = a.shape
print("Nt =", Nt, ", N =", N)

# -------------------------
# 5) Covariância
# -------------------------
C = np.cov(a, rowvar=False)
print("Shape da covariância:", C.shape)  # (64, 64)

# -------------------------
# 6) Eigenanalysis
# -------------------------
LAM, E = np.linalg.eig(C)

# Primeira EOF e PC
eof1 = np.real(E[:, 0])
pc1 = np.dot(a, eof1)
pc1 = (pc1 - np.mean(pc1)) / np.std(pc1)

# Segunda EOF e PC
eof2 = np.real(E[:, 1])
pc2 = np.dot(a, eof2)
pc2 = (pc2 - np.mean(pc2)) / np.std(pc2)

# Terceira EOF e PC
eof3 = np.real(E[:, 2])
pc3 = np.dot(a, eof3)
pc3 = (pc3 - np.mean(pc3)) / np.std(pc3)

# Quarta EOF e PC
eof4 = np.real(E[:, 3])
pc4 = np.dot(a, eof4)
pc4 = (pc4 - np.mean(pc4)) / np.std(pc4)

# Quinta EOF e PC
eof5 = np.real(E[:, 4])
pc5 = np.dot(a, eof5)
pc5 = (pc5 - np.mean(pc5)) / np.std(pc5)

# -------------------------
# 7) Plots
# -------------------------
plt.figure(figsize=(12, 10))

# PC1
plt.subplot(511)
plt.plot(pc1, 'r')
plt.title('PC 1')
plt.xlim(0, Nt)

# PC2
plt.subplot(512)
plt.plot(pc2, 'b')
plt.title('PC 2')
plt.xlim(0, Nt)

# PC3
plt.subplot(513)
plt.plot(pc3, 'g')
plt.title('PC 3')
plt.xlim(0, Nt)

# PC4
plt.subplot(514)
plt.plot(pc4, 'c')
plt.title('PC 4')
plt.xlim(0, Nt)

# PC5
plt.subplot(515)
plt.plot(pc5, 'm')
plt.title('PC 5')
plt.xlim(0, Nt)

plt.tight_layout()
plt.show()