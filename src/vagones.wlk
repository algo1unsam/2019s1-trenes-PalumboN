class Vagon {
	var property ultimaRevision = new Date(1,1,2019)
	
	method estaHabilitado() = 
		(new Date() - ultimaRevision) < 30
	
	method hacerMantenimiento() {
		ultimaRevision = new Date()
	}
	
	method pesoMaximo() = 
		self.cargaMaxima() + 80 * self.cantidadDePasajeros()

	method cargaMaxima()
	method cantidadDePasajeros()
}

class VagonDePasajeros inherits Vagon {
	const largo
	const ancho
	const property tieneBanio = false

	override method cantidadDePasajeros() = 
		largo * self.personasPorAncho()

	method personasPorAncho() = 
		if (self.esMuyAncho()) 10 else 8

	method esMuyAncho() = ancho > 3

	override method cargaMaxima() = if (tieneBanio) 300 else 800
}

class VagonDeCarga inherits Vagon {
	const cargaMaximaIdeal
	var property maderasSueltas = 0
	
	override method cantidadDePasajeros() = 0

	method tieneBanio() = false

	override method cargaMaxima() = cargaMaximaIdeal - 400 * maderasSueltas

	override method hacerMantenimiento() {
		super()
		self.arreglarMaderasSueltas()
	}
	
	method arreglarMaderasSueltas() {
		maderasSueltas = (maderasSueltas - 2).max(0)
	}

}

class VagonDormitorio inherits Vagon {
	const compartimientos
	const camasPorCompartimiento
	
	override method cantidadDePasajeros() = compartimientos * camasPorCompartimiento

	method tieneBanio() = true

	override method cargaMaxima() = 1200
}

class VagonConBicis inherits VagonDePasajeros { 
	const cantidadDeBicis
	
	override method cantidadDePasajeros() = 
		(largo - cantidadDeBicis) * self.personasPorAncho()
}