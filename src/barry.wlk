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

	method transformarse() {
		if (0.randomUpTo(100) < 90) {
		transformacion = ssj
		administrador.sumarVida(2)
		game.onTick(60, "ssjimagen", {ssj.cambiarImagen()})
		game.schedule(20000, {self.destransformarse()})
		game.schedule(20000, {contadorVidasBarry.vidas(1)})
		
		} else if(0.randomUpTo(100) < 50){
			transformacion = profitBird
			administrador.sumarVida(1)
			game.schedule(20000, {self.destransformarse()})
			game.schedule(20000, {contadorVidasBarry.vidas(1)})
		} else {
			transformacion = millonario
			administrador.sumarVida(1)
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
}

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
		if (self.transformacion() == profitBird or self.transformacion() == millonario){administrador.sumarMoneda(2)
	} else {administrador.sumarMoneda(1)}
	}
}
object normal {
	var property image = "barrynormal.png"

	method volar() {
		barry.mover(arriba)
		image = "barryvolando.png"
	}

	method caer() {
	  	barry.mover(abajo)
	  	image = "barrynormal.png"
	}
}

object ssj {
	var property imagenes = ["barrysupersj1.png", "barrysupersj2.png", "barrysupersj3.png","barrysupersj4.png"]
	var property imagenActualIndex = 0
	var property imagenesPoder = ["ataq1.png", "ataq8.png","ataq3.png","ataq4.png","ataq8.png","ataq6.png","ataq7.png","ataq8.png"]
	var property imagenesActual = imagenes
	var property ki = 100

	method volar() {
		barry.mover(arriba)
	}

	method caer() {
	  	barry.mover(abajo)
	}

	method lanzarPoder() {
	  if (contadorMonedas.monedas()>= 10 and barry.transformacion() == ssj and self.ki() == 100){
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
	 imagenesActual = imagenes
	 game.onTick(60, "ssjimagen", {self.cambiarImagen()}) 
	}

	method image() {
		return imagenesActual.get(imagenActualIndex)
	}

	method cambiarImagen() {
        imagenActualIndex = (imagenActualIndex + 1) % imagenes.size()
    }

	method colisiono(personaje) {
		administrador.sacarVida(1)
        personaje.destransformarse()
        game.removeTickEvent("ssjimagen")
	}
}

object picolo {
	var property imagenes = ["pi1.png","pi2.png","pi3.png","pi4.png","pi5.png","pi6.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png","pi4.png","pi7.png","pi8.png"]
	var property imagenActualIndex = 0
	var property position = game.at(4, 4)
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
	var property position = game.at(4, 6)
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




object profitBird {
	var property image = "goldbird3.png"

	method volar() {
		barry.mover(arriba)
		image = "goldbird1.png"
	}

	method caer() {
	  	barry.mover(abajo)
	  	image = "goldbird3.png"
	}

	method colisiono(personaje) {
		administrador.sacarVida(1)
        personaje.destransformarse()
	}
}

object barryConEscudo {
	var property image = "barrynormalconescudo.png"
	
	method volar() {
		barry.mover(arriba)
		image = "barryvolandoconescudo.png"
	}

	method caer() {
	  	barry.mover(abajo)
	  	image = "barrynormalconescudo.png"
	}

	method colisiono(personaje) {
		administrador.sacarVida(1)
        personaje.destransformarse()
	}
}

object millonario {
	var property image = "barryrich1.png"

	method volar() {
		barry.mover(arriba)
		image = "barryrich2.png"
	}

	method caer() {
	  	barry.mover(abajo)
	  	image = "barryrich1.png"
	}

	method colisiono(personaje) {
		administrador.sacarVida(1)
        personaje.destransformarse()
	}
}

