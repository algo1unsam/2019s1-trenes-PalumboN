
class Formacion {
	const vagones = []

	method pasajerosQuePuedeLlevar() = 
		vagones.sum{ vagon => vagon.cantidadDePasajeros() }	

	method cantidadDeBanios() = 
		vagones.count{ vagon => vagon.tieneBanio() }

	method hacerMatenimiento() {
		vagones.forEach{ vagon => vagon.hacerMantenimiento() }
	}
	
	method pesoMaximo() = 
//		vagones.sum{ vagon => 
//			vagon.cargaMaxima() + 80 * vagon.cantidadDePasajeros()
//		}
		vagones.sum{ vagon => vagon.pesoMaximo() }
}
