
class Formacion {
	const vagones = []

	method pasajerosQuePuedeLlevar() = 
		vagones.sum{ vagon => vagon.cantidadDePasajeros() }	

	method cantidadDeBanios() = 
		vagones.count{ vagon => vagon.tieneBanio() }

	method estaHabilitada() = 
		vagones.all{ vagon => vagon.estaHabilitado() }

	method hacerMatenimiento() {
		vagones.forEach{ vagon => if (vagon.pesoMaximo() > 2000) vagon.hacerMantenimiento() }
	}
}
