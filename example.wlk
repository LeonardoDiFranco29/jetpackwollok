object pepita {

  var energia = 100

  method volar(distancia) {
    energia = energia - 10 - distancia
  }

  method comer(alimento) {
    energia = energia + alimento.energiaQueAporta()
  }

  method energia() {
    return energia
  }

}
object pepon {
    var energia = 30

    method comer(alimento){
        energia = energia + (alimento.energiaQueAporta() / 2)
    }

    method volar(distancia) {
    energia = energia - 20 - 2*distancia
  }

    method decirEnergia() {
      return energia
    }
}
object alpiste {
  
  method energiaQueAporta() {
    return 20
  }

}

object manzana {
  
  var madurez = 1
  const base = 5

  method energiaQueAporta() {
    return madurez * base
  }

  method madurar() {
    self.madurez(madurez + 1) /* Self = manzana porque está dentro del objeto manzana */
  }

  method madurez(_madurez) { /* Setter */
    madurez = _madurez
  }
}

object roque {

  method alimentar(alimento) {
    /*.comer(alimento)*/
  }

  method cenas() {
    
  }
}