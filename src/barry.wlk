import wollok.game.*
import posiciones.*
import extras.*
import menu.*

object barry {
	var property position = game.at(1,5)
	var property transformacion = normal

	method image() {
		return transformacion.image()
	}

	method mover(direccion) {
        const nuevaPosicion = direccion.siguiente(self.position()) 
        tablero.validarDentro(nuevaPosicion) // Validar el movimiento
        self.position(nuevaPosicion) // Actualizar la posición 
    }

	method volar() {
	  	transformacion.volar()
	}
	
    method caer() {
	  	transformacion.caer()
	}
	
	/*
	method equiparseEscudo() {
		if (contadorMonedas.monedas() >= 20 and fondoJuego.nivel() == 2 ){
		transformacion = barryConEscudo
		administrador.sumarVida(1)
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})} 
		else if (contadorMonedas.monedas() >= 50 and fondoJuego.nivel() == 3){
		transformacion = barryConEscudo
		administrador.sumarVida(1)
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})}
		else if (contadorMonedas.monedas() >= 75 and fondoJuego.nivel() == 4){
		transformacion = barryConEscudo
		administrador.sumarVida(1)
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})}
		else if (contadorMonedas.monedas() >= 100 and fondoJuego.nivel() == 5){
		transformacion = barryConEscudo
		administrador.sumarVida(1)
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})}
	}
	*/

	method equiparseEscudo() {
		transformacion = barryConEscudo
		administrador.sumarVida(1)
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)}) 
	}

	/*
	method transformarse() {
		if (0.randomUpTo(100) < 5) {
			transformacion = ssj
			administrador.sumarVida(2)
			game.onTick(60, "ssjimagen", {ssj.cambiarImagen()})
			self.destransformacion()
		} else if(0.randomUpTo(100) < 90){
			transformacion = profitBird
			administrador.sumarVida(1)
			self.destransformacion()
		} else {
			transformacion = millonario
			administrador.sumarVida(1)
			self.destransformacion()
		}
	}
	*/

	method transformarse() {
		if (0.randomUpTo(100) < 90) {
			self.transformarseA(ssj)
			game.onTick(60, "ssjimagen", {ssj.cambiarImagen()})
			self.destransformacion()
		} else if(0.randomUpTo(100) < 5){
			self.transformarseA(profitBird)
			self.destransformacion()
		} else {
			self.transformarseA(millonario)
			self.destransformacion()
		}
	}

	method transformarseA(_transformacion) {
		transformacion = _transformacion
		administrador.sumarVida(_transformacion.vidas())
	}

	method destransformacion() {
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})
	}
	
		/*
		transformacion = gravedad
		game.removeTickEvent("gravedad")
		//game.onTick(50, "subirGravedad", {self.volar()})
		administrador.sumarVida(1)
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})

		if (0.randomUpTo(100) < 30) {
        transformacion = "ssj"  // 30% de probabilidad de convertirse en ssj
		contadorVidasBarry.agregarVidas(2)
		game.onTick(60, "ssjimagen", {self.cambiarImagen()} )
    } else {
        transformacion = "gravedad"  // 70% de probabilidad de convertirse en gravedad
		game.removeTickEvent("gravedad")
		contadorVidasBarry.agregarVidas(1)
    }	*/	

	method destransformarse() {
		transformacion = normal
		game.removeTickEvent("ssjimagen")
		ssj.ki(100)
		picolo.ponerImagenesDefault()
		vegeta.ponerImagenesDefault()
		gohan.ponerImagenesDefault()
		//game.removeTickEvent("bajarGravedad")
		//game.removeTickEvent("subirGravedad")
		//generadorDeObjetos.gravedad()
	}

	method agarroMoneda() {
		transformacion.sumarMoneda()
	}

	method lanzarPoder() {
		transformacion.lanzarPoder()
	}
}

class Transformacion {
	var property image
	var property vidas

	method volar() {
		barry.mover(arriba)
		self.ponerImagenVolando()
	}

	method ponerImagenVolando()
	
	method caer() {
		barry.mover(abajo)
		self.ponerImagenCayendo()
	}

	method ponerImagenCayendo()
	
	method lanzarPoder() {

	}

	method sumarMoneda() {
		administrador.sumarMoneda(self.cantidadMonedasQueAgarra())
	}

	method cantidadMonedasQueAgarra()

	method colisiono(personaje) {
		administrador.sacarVida(1)
        personaje.destransformarse()
	}
}

object normal inherits Transformacion(image = "barrynormal.png", vidas = 1) {

	override method ponerImagenVolando() {
		image = "barryvolando.png"
	}

	override method ponerImagenCayendo() {
	  	image = "barrynormal.png"
	}

	override method cantidadMonedasQueAgarra() {
		return 1
	}

	override method colisiono(personaje) {

	}
}

object ssj inherits Transformacion (image = ["barrysupersj1.png", "barrysupersj2.png", "barrysupersj3.png","barrysupersj4.png"], vidas = 2){
	var property imagenActualIndex = 0
	var property imagenesPoder = ["ataq1.png", "ataq8.png","ataq3.png","ataq4.png","ataq8.png","ataq6.png","ataq7.png","ataq8.png"]
	var property imagenesActual = image
	var property ki = 100

	override method lanzarPoder() {
	  if (contadorMonedas.monedas()>= 30 and self.ki() == 100){
		game.removeTickEvent("ssjimagen")
		imagenesActual = imagenesPoder
		game.onTick(200, "ssjimagen", {self.cambiarImagen()})
		game.schedule(10000, {self.ponerImagenesDefault()})
		picolo.lanzarPoder()
		vegeta.lanzarPoder()
		gohan.lanzarPoder()
		administrador.sumarVida(20)
		self.ki(0)
	  }
	}

	method ponerImagenesDefault() {
	 game.removeTickEvent("ssjimagen") 
	 imagenesActual = image
	 game.onTick(60, "ssjimagen", {self.cambiarImagen()}) 
	}

	override method image() {
		return imagenesActual.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % image.size()
    }

	override method colisiono(personaje) {
		super(personaje)
        game.removeTickEvent("ssjimagen")
	}

	override method cantidadMonedasQueAgarra() {
		return 1
	}

	override method ponerImagenVolando() {

	}

	override method ponerImagenCayendo() {

	}
}

object picolo {
	var property imagenes = ["pi1.png","pi2.png","pi3.png","pi4.png","pi5.png","pi6.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png"]
	var property imagenActualIndex = 0
	var property position = game.at(8, 4)
	var property transformacion = self

	method agarroMoneda() {
		administrador.sumarMoneda(1)
	}

	method lanzarPoder() {
	  
	  game.addVisual(self)
	  game.onTick(120, "picolo", {self.cambiarImagen()})
	  game.schedule(15000, {self.ponerImagenesDefault()})
	  game.schedule(20000, {self.ponerImagenesDefault()})
	  game.onCollideDo(self, {cosa => cosa.colisiono(self)})
	}

	method ponerImagenesDefault() {
	 game.removeTickEvent("picolo") 
	 game.removeVisual(self)
	  
	}

	method image() {
		return imagenes.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method colisiono(personaje) {
		
	}
}

object vegeta {
	var property imagenes = ["ve1.png","ve2.png","ve3.png","ve4.png","ve5.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png"]
	var property imagenActualIndex = 0
	var property position = game.at(4, 1)
	var property transformacion = self

	method agarroMoneda() {
		administrador.sumarMoneda(1)
	}

	method lanzarPoder() {
	  game.addVisual(self)
	  game.onTick(200, "vegeta", {self.cambiarImagen()})
	  game.schedule(15000, {self.ponerImagenesDefault()})
	  game.schedule(20000, {self.ponerImagenesDefault()})
	  game.onCollideDo(self, {cosa => cosa.colisiono(self)})
	}

	method ponerImagenesDefault() {
	 game.removeTickEvent("vegeta") 
	 game.removeVisual(self)
	  
	}

	method image() {
		return imagenes.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method colisiono(personaje) {
		
	}
}

object gohan {
	var property imagenes = ["gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png","gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png","gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png"]
	var property imagenActualIndex = 0
	var property position = game.at(7, 6)
	var property transformacion = self

	method agarroMoneda() {
		administrador.sumarMoneda(1)
	}

	method lanzarPoder() {
	  
	  game.addVisual(self)
	  game.onTick(200, "gohan", {self.cambiarImagen()})
	  game.schedule(15000, {self.ponerImagenesDefault()})
	  game.schedule(20000, {self.ponerImagenesDefault()})
	  game.onCollideDo(self, {cosa => cosa.colisiono(self)})
	}

	method ponerImagenesDefault() {
	 game.removeTickEvent("gohan") 
	 game.removeVisual(self)
	  
	}

	method image() {
		return imagenes.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method colisiono(personaje) {
		
	}
}

object profitBird inherits Transformacion(image = "goldbird3.png", vidas = 1) {

	override method ponerImagenVolando() {
		image = "goldbird1.png"
	}

	override method ponerImagenCayendo() {
	  	image = "goldbird3.png"
	}

	override method cantidadMonedasQueAgarra() {
		return 2
	} 
}

object barryConEscudo inherits Transformacion(image = "barrynormalconescudo.png", vidas = 1){
	
	override method ponerImagenVolando() {
		image = "barryvolandoconescudo.png"
	}

	override method ponerImagenCayendo() {
	  	image = "barrynormalconescudo.png"
	}

	override method cantidadMonedasQueAgarra() {
		return 1
	} 
}

object millonario inherits Transformacion (image = "barryrich1.png", vidas = 1){

	override method ponerImagenVolando() {
		image = "barryrich2.png"
	}

	override method ponerImagenCayendo() {
	  	image = "barryrich1.png"
	}

	override method cantidadMonedasQueAgarra() {
		return 2
	} 
}

