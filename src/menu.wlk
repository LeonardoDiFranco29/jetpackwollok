import wollok.game.*
import barry.*
import posiciones.*
import extras.*
import randomizer.*

object administradorEscudo {
    method verificarEscudo() {
        barry.equiparseEscudo()
        // if (contadorMonedas.monedas() >= 20 and fondoJuego.nivel() == 2 ){
		//     barry.equiparseEscudo()
        // } else if (contadorMonedas.monedas() >= 50 and fondoJuego.nivel() == 3){
		//     barry.equiparseEscudo()
		// } else if (contadorMonedas.monedas() >= 75 and fondoJuego.nivel() == 4){
        //     barry.equiparseEscudo()
		// } else if (contadorMonedas.monedas() >= 100 and fondoJuego.nivel() == 5){
		//     barry.equiparseEscudo()
        // }
    }
}

object administrador {

    method sumarMoneda(num) {
        contadorMonedas.agregarMoneda(num)
    }

    method sacarMoneda(num) {
        contadorMonedas.restarMoneda(num)
    }

    /*
    method sumarVida(vida) {
        barry.agregarVidas(vida)
    }

    method sacarVida(vida) {
        barry.restarVidas(vida)
    } 
    */

    method pararJuegoYMostrarGameOver() {
	    game.removeVisual(botonPlay)
	    //game.removeVisual(fondoJuego)
	    game.addVisual(fondoFinish)
        game.addVisual(hasVolado)
	    game.addVisual(gameOver)
        reloj.position(game.at(5,7))
        contadorMonedas.position(game.at(6,2))
        contadorVidasBarry.position(game.at(11,11))
	    game.schedule(100,{game.stop()})
    }
} 

object contadorMonedas {
    var property monedas = 0
    var property position = game.at(0,8)
  
    method agregarMoneda(num) {
        monedas += num
    }
    method restarMoneda(num) {
       if(self.verificarResta(num)){
        monedas -= num
       } else {monedas=0}
    }

    method verificarResta(num) {
        return monedas - num > 0
    }

    method text() {
        return monedas.toString() +"\n" + "\n" + "\n"
    }

    method textColor() {
        return "FFFF00FF"
    }

}

object contadorVidasBarry {
    var property position = game.at(0,8)
    
    method vidas(barry) {
        return barry.vidas()
    }

    method text() {
        return barry.vidas().toString()
    }

    method textColor() {
        return "FF0000FF"
    }
}

object fondoMenu {
	method image() {
        return "menu.png"
    }

    method position() = game.at(0,0)
}

object hasVolado {
    method image() {
        return "Volado.png"
    } 

    method position() = game.at(4,8)
}

object fondoFinish {
	method image() {
        return "recuentoMonedascopia1.png"
    }

    method position() = game.at(1,1)
}

object fondoJuego {
    var property nivel = 1

    method image() {
        return "fondoo" + nivel + ".png"
    }

    method subirNivel() {
        nivel += 1
    }

    method position() = game.at(0,0)
}

object botonPlay {
    method image() {
        return "play.png"
    }

    method position() = game.at(4,1)
}

object gameOver {
    method image() {
        return "gameover.png"
    }

    method position() = game.at(6,10)
}
class Menu {
    var property juegoIniciado = false

    method init() {
        game.title("jetpackjoyride")
	    game.height(10)
	    game.width(12)
	    game.cellSize(50)
        
        game.addVisual(fondoMenu) // Mostrar el fondo del menú
        game.addVisual(botonPlay)
        // Configurar la acción para iniciar el juego cuando se presiona "Enter"
        keyboard.enter().onPressDo({self.startGame()})// Iniciar el juego al presionar "Enter"
    }

    method startGame() {
        self.juegoIniciado(true) // Marcar el juego como iniciado
        game.removeVisual(fondoMenu) // Limpiar visuales del menú
        game.removeVisual(botonPlay)
        // Llamar a la función de inicialización del juego
        self.iniciarJuego()
    }


    method iniciarJuego() {
	    game.addVisual(fondoJuego)
	    game.addVisual(reloj)
	    game.addVisual(barry)
        game.addVisual(contadorMonedas)
        game.addVisual(contadorVidasBarry)
    

	    // Crear instancias de clases
        generadorDeMisiles.construir()
        game.schedule(1000, {generadorDeMisiles.construir()})
        game.onTick(50000, "masMisiles" ,{generadorDeMisiles.construir()})
        game.onTick(50000, "masVelocidad" ,{generadorDeMisiles.aumentarVelocidad()})
	    generadorDeMonedas.construir()
        game.schedule(500, {generadorDeMonedas.construir()})
        game.schedule(700, {generadorDeMonedas.construir()})
        game.schedule(1000, {generadorDeMonedas.construir()})
        game.schedule(1500, {generadorDeMonedas.construir()})
        game.schedule(2000, {generadorDeMonedas.construir()})
        game.schedule(25000, {generadorDeTokens.construir()})
        generadorDeObjetos.construirReloj()
        generadorDeObjetos.gravedad()
        

	    keyboard.up().onPressDo({barry.volar()})
        keyboard.space().onPressDo({barry.lanzarPoder()})
	    //keyboard.s().onPressDo({generadorDeObjetos.subirGravedad()})
        //keyboard.w().onPressDo({generadorDeObjetos.bajarGravedad()})
  
        game.onTick(50000, "fondo", {fondoJuego.subirNivel()})
        game.onTick(50100, "barryescudo", {administradorEscudo.verificarEscudo()})
        game.schedule(250200, {administrador.pararJuegoYMostrarGameOver()})
        // Colisiones
        game.onCollideDo(barry, {cosa => cosa.colisiono(barry)}) 
         
    }
}