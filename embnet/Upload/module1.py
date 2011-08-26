# REPASO

# Defino la funcion x que devuelve el entero 3
x = 3
# Defino una funcion "inline"
pordos = lambda y: y*2
# Defino una funcion comun
def portres(y):
    return y*3

# Aplicar tenia la caracteristica de recibir
# funciones como parametros, aca todo es una funcion!!
aplicar = lambda y,z: y(z)
aplicarr = lambda y,z,w: y(z(w))
# imprimo
#print (aplicar(pordos,x))
#print (aplicarr(pordos,portres,x))

# LISTAS POR COMPRENSION

# Lista comun
l1 = [1,2,3]
print l1

# Lista un poco más inteligente
# range me devuelve del 0 al 29
# hago for para todos los e en ese rango
l2 = [e for e in range(30)]
print l2

# Puedo anidar incluso
l3 = [[e,i] for e in range(10) for i in range(10)]
print l3

# MAP

# aplico
res = map(portres, l2)
print res
# no es lo mismo que multiplicar la lista
resdos = portres(l2)
print resdos

