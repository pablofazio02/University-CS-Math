## RESOLUCIÓN DEL PROBLEMA DE GESTIÓN DE CARTERAS CON HOPFIELD

import numpy as np
import pandas as pd

class redHopfieldCarteras:
    
    def __init__(self, media, covarianza, N, K, epsilon, delta, lambd, T, R, eta):
        
        self.media = media
        self.covarianza = covarianza
        self.N = N
        self.K = K
        self.epsilon = epsilon
        self.delta = delta
        self.lambd = lambd
        self.T = T
        self.R = R
        self.eta = eta

        # Cáculo de la matriz de pesos y sesgo de la red de Hopfield
        self.pesos = -2 * self.lambd * self.covarianza
        self.sesgo = (1 - self.lambd) * self.media

    def funcionActivacion(self, h, beta):
        return self.epsilon + (self.delta - self.epsilon) / (1 + np.exp(-beta * h))

    def funcionEnergia(self, cartera):
        return -0.5 * np.sum(cartera * self.pesos * cartera) - np.sum(self.sesgo * cartera)

    def normalizar_cartera(self, cartera):

        # 1. Identificar activos seleccionados (valores no nulos)
        activos_seleccionados = np.nonzero(cartera)

        # 2. Asegurar que no haya más de K activos seleccionados
        if len(activos_seleccionados) > self.K:
            excesos = len(activos_seleccionados) - self.K
            # Ordenar activos por valor ascendente y eliminar los más pequeños
            activos_a_eliminar = activos_seleccionados[np.argsort(cartera[activos_seleccionados])[:excesos]]
            cartera[activos_a_eliminar] = 0
            activos_seleccionados = np.nonzero(cartera)

        # 3. Asegurar que los valores de los activos estén en el rango [epsilon, delta]
        cartera[activos_seleccionados] = np.clip(cartera[activos_seleccionados], self.epsilon[activos_seleccionados], self.delta[activos_seleccionados])

        # 4. Normalizar para que la suma sea 1
        suma_actual = np.sum(cartera[activos_seleccionados])
        if suma_actual > 0:
            cartera[activos_seleccionados] /= suma_actual

        return cartera

    def initialise_portfolios_randomly(self, num_carteras):
        carteras = np.zeros((num_carteras, self.N))
        for i in range(num_carteras):
            indices = np.random.choice(self.N, self.K, replace=False)
            for j in range(self.K):
                carteras[i, indices[j]] = self.epsilon[indices[j]] + (self.delta[indices[j]] - self.epsilon[indices[j]]) * np.random.rand()
            carteras[i] = self.normalizar_cartera(carteras[i])
        return carteras

    def prune_worst_neuron(self, carteras_optimas):
        min_energy_index = np.argmin([self.funcionEnergia(cartera) for cartera in carteras_optimas])
        carteras_optimas[min_energy_index] = 0
        return carteras_optimas

    def optimise_portfolios(self, cartera_candidata, beta):
        X = np.zeros((self.N, self.R))
        X[:, 1] = cartera_candidata
        for e in range(2, self.R):
            X[:, e] = X[:, e - 1]
            for i in range(1, self.N):
                h = 0
                for j in range(1, self.N):
                    h = h + self.pesos[i, j] * X[j, e]
                X[i, e] = X[i, e] + self.eta * (self.epsilon[i] + (self.delta[i] - self.epsilon[i]) / (1 + np.exp(-beta * (h - self.sesgo[i]))))
        carteras_optimas = X[:, self.R - 1]
        carteras_optimas = self.prune_worst_neuron(carteras_optimas)
        carteras_optimas = self.normalizar_cartera(carteras_optimas)
        return carteras_optimas
        

    def evaluate_portfolios(self, lambd_values, num_carteras):

        # La estructura de H es la siguiente:  H = [portfolio | valor portfolio] :: M x (N+1)
        H = np.zeros((num_carteras, self.N + 1))

        for valor in lambd_values:

            self.lambd = valor
            self.pesos = -2 * valor * self.covarianza
            self.sesgo = (1 - valor) * self.media
            
            carteras = self.initialise_portfolios_randomly(num_carteras)

            H = [(cartera, self.funcionEnergia(cartera)) for cartera in carteras]

            carteraMinima, funcionObjetivoMinima = min(H, key=lambda x: x[1])

            beta = abs(10/funcionObjetivoMinima)

            for _ in range(self.T):

                indice_candidata = np.random.randint(len(carteras))
                cartera_candidata = carteras[indice_candidata]
                S = int(3 * self.K / 2)
                Sindexes = np.random.choice(self.N, S, replace=False)

                for k in range(S, self.K + 1, -1):
                    X = np.zeros((self.N, self.R))
                    X[:, 1] = cartera_candidata
                    for e in range(2, self.R):
                        X[:, e] = X[:, e - 1]
                        for i in range(1, self.N):
                            h = 0
                            for j in range(1, self.N):
                                h = h + self.pesos[i, j] * X[j, e]
                            X[i, e] = X[i, e] + self.eta * (self.epsilon[i] + (self.delta[i] - self.epsilon[i]) / (1 + np.exp(-beta * (h - self.sesgo[i]))))

                    carteras_optimas = X[:, self.R - 1]
                    carteras_optimas = self.prune_worst_neuron(carteras_optimas)
                    carteras_optimas = self.normalizar_cartera(carteras_optimas)

                carteras_optimas = self.optimise_portfolios(cartera_candidata, beta)
                H.append((carteras_optimas, self.funcionEnergia(carteras_optimas)))
            beta = beta / 0.95
        # Ordenar carteras por valor de la función objetivo
        H = sorted(H, key=lambda x: x[1], reverse=True)
        return H

def cargar_datos_excel(filepath):
    """ Calcula la media de rendimientos y la matriz de covarianza."""
    
    with open(filepath, 'r') as file:
        lineas = file.readlines()

    nombres_activos = lineas[0].strip().split(',')[1:]
    datos = []
    for linea in lineas[1:]:
        valores = linea.strip().split(',')[1:]
        if valores:
            datos.append([float(v) if v else 0.0 for v in valores])

    df = pd.DataFrame(datos, columns=nombres_activos)
    print("\nDatos cargados desde el archivo .csv:")
    print(df)
    media = df.mean().values
    covarianza = df.cov().values

    print("\nMedia de rendimientos por activo:")
    print(pd.Series(media, index=nombres_activos))
    print("\nMatriz de covarianza de los activos:")
    print(pd.DataFrame(covarianza, index=nombres_activos, columns=nombres_activos))

    return media, covarianza

def main():
    
    # Cargo e imprimo los datos del archivo .csv
    ruta_archivo = "C:\\Users\\pablo\\Downloads\\5º Informática + Matemáticas UMA\\1º Cuatrimestre\\Modelos Computacionales\\Prácticas - Modelos Computacionales\\Práctica Optativa - Bloque II\\grupo_2023_0.csv"
    media, covarianza = cargar_datos_excel(ruta_archivo)

    # Número de activos/assets no nulos    
    K = 5
    # Número de activos totales
    N = len(media)
    # Hiperparámetro del modelo: Número de carteras iniciales
    num_carteras = 50

    epsilon = 0.01 * np.ones(N)
    delta = np.ones(N)
    # Valores de lambda a probar (desde 0 a 1 en incrementos de 0.1)
    lambd_values = np.linspace(0, 1, 10) 

    T = 1000               # Limite de optimización de portfolios generados
    R = 50                 # Limite de epocas para la red de Hopfield
    eta = 0.1

    red = redHopfieldCarteras(media, covarianza, N, K, epsilon, delta, 0, T, R, eta)
    carteras_optimas = red.evaluate_portfolios(lambd_values, num_carteras)

    print("\nCarteras Óptimas:\n")
    # Imprimir las primeras num_carteras carteras óptimas
    for i in range(num_carteras):
        print(f"Cartera {i + 1}:\n{carteras_optimas[i][0]}\nFunción Energía: {carteras_optimas[i][1]}\n")

if __name__ == "__main__":
    main()