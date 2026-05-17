import os
import numpy as np

# Lista de estações
stations = ['VICO', 'UFPR', 'TOPL', 'TOGU', 'SSA1', 'SPAR', 'SMAR', 'SJRP', 
            'SCLA', 'SCCH', 'SAVO', 'SALU', 'SAGA', 'ROSA', 'ROJI', 'ROGM', 
            'ROCD', 'RNNA', 'RNMO', 'SJCG', 'RIOD', 'RIOB', 'PRMA', 'PRGU', 
            'PPTE', 'POVE', 'POLI', 'POAL', 'PITN', 'PISR', 'PEPE', 'PBCG', 
            'PAIT', 'ONRJ', 'NEIA', 'NAUS', 'MTSR', 'MTSF', 'MTCO', 'MTCN', 
            'MSCG', 'MGUB', 'MGTP', 'MGMC','MGIN', 'MGBH', 'MABA', 'IMPZ', 
            'IMBT', 'ILHA', 'GOJA', 'CUIB', 'CHPI', 'CEFT', 'CEFE', 'CEEU', 
            'BRFT', 'BRAZ', 'BOAV', 'BELE', 'BAVC', 'BATF', 'BAIR', 'ALAR']

# Gerar lista de arquivos
folder_path = r"C:\Users\vikla\Downloads\dados_tec_2011"
files = [os.path.join(folder_path, f"{station}-2011-08(01-31).txt") for station in stations]

# Inicializar a matriz de diferenças
matrix_diffTEC = []

# Para cada estação, processar o arquivo
for file in files:
    # Usar skiprows para pular a primeira linha de cabeçalho
    data = np.loadtxt(file, delimiter='\t', skiprows=1, dtype=str)  # Ler como string para processar melhor
    
    # Substituir vírgulas por pontos nos dados numéricos
    data = np.char.replace(data, ',', '.')  # Substituindo a vírgula por ponto
    
    # Substituir os valores '-999.0' por NaN
    data[data == '-999.0'] = np.nan  # Substituindo o valor '-999.0' por 'NaN'
    
    # Tentar converter os dados para float64
    try:
        data = data.astype(np.float64)  # Converter os dados para float64
    except ValueError as e:
        print(f"Erro na conversão do arquivo {file}: {e}")
        continue
    
    media = data[:, 0]  # Média
    med_plus = data[:, 1]  # Mediana + Desvio
    med_minus = data[:, 2]  # Mediana - Desvio
    
    # Preencher NaN com a média
    med_plus[np.isnan(med_plus)] = media[np.isnan(med_plus) + 1]
    med_minus[np.isnan(med_minus)] = media[np.isnan(med_minus) + 1]
    
    # Dados de VTEC (assumindo que estão na coluna 4 até a última)
    vtec_data = data[:, 4:]  # Dados de VTEC
    vtec_data = vtec_data.flatten()  # Achatar para um vetor único

    # Calcular a diferença do TEC
    diff_TEC = vtec_data - media  # Diferença VTEC - média

    # Adicionar a coluna de diferenças à matriz
    matrix_diffTEC.append(diff_TEC)

# Converter a lista em um array numpy
matrix_diffTEC = np.array(matrix_diffTEC).T  # Transpor para que cada estação seja uma coluna

# Salvar a matriz de diferenças
output_folder = r"C:\Users\vikla\Downloads\dados_tec_2011\formatado"
output_file = os.path.join(output_folder, "matrix_diffTECAug2011.txt")
np.savetxt(output_file, matrix_diffTEC, delimiter=' ')
print(f"Arquivo salvo em: {output_file}")
