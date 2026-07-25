# Práctica de Robótica Móvil: Robot Diferencial

**Alumno:** Ismael Beltrán Espinoza  
**Materia:** Robótica Móvil  
**Software Utilizado:** MATLAB

---

# Descripción del Proyecto

Este repositorio contiene el desarrollo de las prácticas realizadas para el análisis, modelado y control de un robot móvil diferencial mediante simulaciones en MATLAB.

El trabajo se encuentra dividido en tres módulos principales:

- Cinemática Directa
- Cinemática Inversa
- Control Cinemático

Cada módulo incluye código fuente, imágenes de resultados, animaciones GIF y datos obtenidos durante las simulaciones.

---

# Objetivos

- Comprender el modelo cinemático de un robot diferencial.
- Analizar el comportamiento del robot bajo diferentes velocidades de ruedas.
- Implementar trayectorias libres mediante cinemática directa.
- Generar trayectorias deseadas mediante cinemática inversa.
- Implementar control cinemático para regular la posición del robot hacia un objetivo.
- Analizar el efecto de las limitaciones físicas de los actuadores mediante saturación proporcional.

---

# Estructura del Repositorio

```text
Robot_Diferencial_Beltran_Ismael/

├── README.md

├── REPORTE/
│   └── Reporte_Practica.pdf

├── CINEMATICA_DIRECTA/
│   ├── Codigo/
│   ├── Imagenes/
│   ├── Animaciones/
│   └── Datos/

├── CINEMATICA_INVERSA/
│   ├── Codigo/
│   ├── Imagenes/
│   ├── Animaciones/
│   └── Datos/

└── CONTROL/
    ├── Codigo/
    ├── Imagenes/
    ├── Animaciones/
    └── Datos/
```

---

# Cinemática Directa

En esta práctica se implementó el modelo cinemático directo de un robot diferencial.

A partir de las velocidades angulares de las ruedas se calcularon:

- Posición en X
- Posición en Y
- Orientación del robot

## Actividades realizadas

- Simulación de 8 casos de movimiento.
- Análisis de trayectorias rectas, curvas y giros.
- Diseño de trayectoria libre tipo circuito GOKART.
- Visualización en 3D.
- Generación de animaciones GIF.

## Resultados obtenidos

- Trayectorias en 2D y 3D.
- Animación del robot diferencial.
- Circuito de GOKART completamente funcional.
- GIF con vista 3D del robot recorriendo el circuito.

---

# Cinemática Inversa

En esta práctica se desarrolló el modelo cinemático inverso para un robot diferencial.

La trayectoria deseada fue una circunferencia.

## Actividades realizadas

- Definición de trayectoria circular.
- Cálculo de velocidad lineal y angular.
- Obtención de velocidades angulares de las ruedas.
- Comparación entre trayectoria deseada y trayectoria obtenida.
- Generación de animaciones GIF.

## Resultados obtenidos

- Trayectoria circular deseada.
- Trayectoria circular obtenida.
- Error de seguimiento mínimo.
- Gráficas de velocidades lineales y angulares.
- Animación del robot siguiendo la trayectoria.

---

# Control Cinemático

En esta práctica se implementó un controlador cinemático para llevar el robot desde una posición inicial hasta una posición objetivo.

## Parámetros utilizados

- Distancia entre ruedas:

```text
L = 0.18 m
```

- Radio de ruedas:

```text
r = 0.03 m
```

- Ganancia lineal:

```text
kρ = 0.3
```

- Ganancia angular:

```text
kθ = 4
```

- Tolerancia de llegada:

```text
0.03 m
```

- Saturación máxima:

```text
20 rad/s
```

---

## Caso 1: Sin saturación

Características:

- El controlador utiliza directamente las velocidades calculadas.
- El robot llega a la meta en menor tiempo.
- Las velocidades de las ruedas pueden superar límites físicos.

Resultados obtenidos:

```text
Error final = 0.0000 m
Tiempo de llegada = 18.23 s

Theta D máxima = 80.14 rad/s
Theta I máxima = 62.84 rad/s

Distancia recorrida = 7.13 m
```

---

## Caso 2: Con saturación proporcional

Características:

- Las velocidades máximas se limitan a 20 rad/s.
- Se preserva la relación entre ambas ruedas.
- La trayectoria se mantiene prácticamente igual.

Resultados obtenidos:

```text
Error final = 0.0000 m
Tiempo de llegada = 20.00 s

Theta D máxima = 20.00 rad/s
Theta I máxima = 20.00 rad/s

Distancia recorrida = 7.13 m
```

---

# Comparación de Resultados

| Indicador | Sin Saturación | Con Saturación |
|------------|------------|------------|
| Error Final | 0.0000 m | 0.0000 m |
| Tiempo de Llegada | 18.23 s | 20.00 s |
| θ̇D Máxima | 80.14 rad/s | 20.00 rad/s |
| θ̇I Máxima | 62.84 rad/s | 20.00 rad/s |
| Distancia Recorrida | 7.13 m | 7.13 m |

---

# Animaciones Generadas

El repositorio incluye animaciones GIF de:

- Trayectorias libres.
- Circuito de GOKART.
- Trayectoria circular.
- Control cinemático.
- Robot diferencial en vista 3D.

---

# Instrucciones de Ejecución

1. Descargar o clonar el repositorio.
2. Abrir MATLAB.
3. Acceder a la carpeta de la práctica deseada.
4. Abrir el archivo `.m`.
5. Presionar **Run**.
6. Esperar la generación de imágenes y animaciones.

No se requieren librerías externas adicionales.

---

# Conclusiones

La cinemática directa permitió analizar el movimiento del robot a partir de las velocidades de las ruedas y diseñar trayectorias complejas como un circuito tipo GOKART.

La cinemática inversa permitió calcular las velocidades necesarias para seguir una trayectoria circular deseada, obteniendo errores mínimos de seguimiento.

Finalmente, el control cinemático demostró ser el método más robusto para conducir el robot hacia una meta, corrigiendo continuamente los errores de posición y orientación. La inclusión de saturación proporcional permitió respetar las restricciones físicas de los motores manteniendo una trayectoria prácticamente idéntica.

---

# Autor

**Ismael Beltrán Espinoza**

Práctica de Robótica Móvil  
Robot Diferencial