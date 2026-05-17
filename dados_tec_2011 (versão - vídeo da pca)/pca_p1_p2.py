import os
import numpy as np
from matplotlib import pyplot as plt
import matplotlib as mpl
mpl.rc('font', size=14)

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

matrix_diffTEC = np.column_stack(matrix_list)
print("Shape da matriz carregada:", matrix_diffTEC.shape)  # (44640, 64)

# -------------------------
# 2) Calcular anomalia e preencher NaNs
# -------------------------
X_anom = matrix_diffTEC - np.nanmean(matrix_diffTEC, axis=0)
X_anom_filled = np.nan_to_num(X_anom, nan=0.0)

# -------------------------
# 3) Padronizar
# -------------------------
a = (X_anom_filled - X_anom_filled.mean()) / X_anom_filled.std()
print(a.mean(), a.std())  # deve dar ~0 e 1

Nt, N = a.shape
print("Nt =", Nt, ", N =", N)

# -------------------------
# 4) Covariância
# -------------------------
C = np.cov(a, rowvar=False)
print("Shape da covariância:", C.shape)  # (64, 64)

# -------------------------
# 5) Eigenanalysis
# -------------------------
LAM, E = np.linalg.eig(C)

# Primeira EOF e PC
eof1 = np.real(E[:,0])
pc1  = np.dot(a, eof1)
pc1 = (pc1 - np.mean(pc1)) / np.std(pc1)

# Segunda EOF e PC
eof2 = np.real(E[:,1])
pc2  = np.dot(a, eof2)
pc2 = (pc2 - np.mean(pc2)) / np.std(pc2)


# -------------------------
# 6) Plots
# -------------------------
plt.figure(figsize=(12,5))
plt.subplot(211)
plt.plot(pc1,'r')
plt.title('PC 1')
plt.xlim(0,Nt)

plt.subplot(212)
plt.plot(pc2,'b')
plt.title('PC 2')
plt.xlim(0,Nt)
plt.tight_layout()
plt.show()
