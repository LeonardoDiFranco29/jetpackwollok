import wollok.game.*
import posiciones.*
import extras.*
import menu.*

object barry {
	var property position = game.at(1,5)
	var property transformacion = normal
	var property vidas = 1

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

	method equiparseEscudo() {
		if(self.puedoPonermeEscudo()){
			transformacion = barryConEscudo
			self.vidas(2)
			game.schedule(20000, {self.destransformarse()})
		}
	}

	method puedoPonermeEscudo() {
		return (contadorMonedas.monedas() >= 20 and fondoJuego.nivel() == 2) or 
				(contadorMonedas.monedas() >= 50 and fondoJuego.nivel() == 3) or 
				(contadorMonedas.monedas() >= 75 and fondoJuego.nivel() == 4) or 
				(contadorMonedas.monedas() >= 100 and fondoJuego.nivel() == 5)
	  
	}

	method transformarse() {
		if (0.randomUpTo(100) < 20) {
			self.transformarseA(ssj)
			game.onTick(60, "ssjimagen", {ssj.cambiarImagen()})
			self.destransformacion()
		} else if(0.randomUpTo(100) < 50){
			self.transformarseA(profitBird)
			self.destransformacion()
		} else {
			self.transformarseA(millonario)
			self.destransformacion()
		}
	}

	method transformarseA(_transformacion) {
		transformacion = _transformacion
		self.vidas(_transformacion.vidas())
	}

	method destransformacion() {
		game.schedule(20000, {self.destransformarse()})
	}

	method destransformarse() {
		transformacion = normal
		game.removeTickEvent("ssjimagen")
		ssj.ki(100)
		picolo.ponerImagenesDefault()
		vegeta.ponerImagenesDefault()
		gohan.ponerImagenesDefault()
		self.vidas(1)
	}

	method agarroMoneda() {
		transformacion.sumarMoneda()
	}

	method lanzarPoder() {
		transformacion.lanzarPoder()
	}

	method restarVidas(vida) {
		vidas -= vida
		contadorVidasBarry.vidas(self)
	}

	method agregarVidas(vida) {
		vidas += vida
		contadorVidasBarry.vidas(self)
	}

	method colisiono() {
		transformacion.colisiono(self)
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
		game.schedule(200, {administrador.pararJuegoYMostrarGameOver()})
	}
}

//Herencia entre los personajes de Dragol Ball, para que hereden de ssj (Hacer class DragonBall)
object ssj inherits Transformacion (image = ["barrysupersj1.png", "barrysupersj2.png", "barrysupersj3.png","barrysupersj4.png"], vidas = 3){
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
		if (personaje.vidas() == 3) {
			personaje.restarVidas(1)
		} else {
			super(personaje)
			game.removeTickEvent("ssjimagen")
		}
	}

	override method cantidadMonedasQueAgarra() {
		return 1
	}

	override method ponerImagenVolando() {

	}

	override method ponerImagenCayendo() {

	}
}

class DragonBall {
	var property imagenes
	var property imagenActualIndex = 0
	var property position

	method agarroMoneda() {
		administrador.sumarMoneda(1)
	}

	method image() {
		return imagenes.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method colisiono() {

	}

	method lanzarPoder() {
	  game.addVisual(self)
	  game.onTick(120, self.nombreDeEventoImagen(), {self.cambiarImagen()})
	  game.schedule(15000, {self.ponerImagenesDefault()})
	  game.schedule(20000, {self.ponerImagenesDefault()})
	  game.onCollideDo(self, {cosa => cosa.colisiono(self)})
	}

	method ponerImagenesDefault() {
	 game.removeTickEvent(self.nombreDeEventoImagen()) 
	 game.removeVisual(self)
	  
	}

	method nombreDeEventoImagen() {
		return self.prefijoDeEvento() + "Imagen" + self.identity()
	}

	method prefijoDeEvento()
}

object picolo inherits DragonBall(imagenes = ["pi1.png","pi2.png","pi3.png","pi4.png","pi5.png","pi6.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png"], position = game.at(8, 4) ) {
	override method prefijoDeEvento() {
		return "picolo"
	}
}

object vegeta inherits DragonBall(imagenes = ["ve1.png","ve2.png","ve3.png","ve4.png","ve5.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png","ve3.png","ve4.png","ve6.png","ve7.png"], position = game.at(4, 1)){
	override method prefijoDeEvento() {
		return "vegeta"
	}
}

object gohan inherits DragonBall(imagenes = ["gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png","gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png","gohan2.png","gohan3.png","gohan4.png","gohan5.png","gohan5.png"], position = game.at(7, 6)){
	override method prefijoDeEvento() {
		return "gohan"
	}
}

object profitBird inherits Transformacion(image = "goldbird3.png", vidas = 2) {

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

object barryConEscudo inherits Transformacion(image = "barrynormalconescudo.png", vidas = 2){
	
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

object millonario inherits Transformacion (image = "barryrich1.png", vidas = 2){

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

