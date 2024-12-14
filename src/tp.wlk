object prueba {}
class Mago {
    var nombre = ""
    var poderInnato = 1
    var objetosMagicos = []
    var resistenciaMagica = 50
    var energiaMagica = null

    method configurar(nombreMago, poderInnatoMago, energiaInicial, resistenciaInicial) {
        nombre = nombreMago
        poderInnato = poderInnatoMago
        energiaMagica = new EnergiaMagica()
        energiaMagica.configurar(energiaInicial)
        resistenciaMagica = resistenciaInicial
    }
    method poderInnato(nuevoPoderInnato) {
        poderInnato = nuevoPoderInnato
    }
    method ResistenciaMagica(nuevaResistencia) {
        resistenciaMagica = nuevaResistencia
    }
    method poderTotal() {
        const poderObjetos = objetosMagicos.sum({ objeto => objeto.poderAportado(self) })
        return poderObjetos * poderInnato
    }
    method agregarObjetoMagico(objeto) {
        objetosMagicos.add(objeto)
    }
    method restarEnergia(cantidad) {
        energiaMagica.restar(cantidad)
    }
    method ganarEnergia(cantidad) {
        energiaMagica.agregar(cantidad)
    }
    method obtenerEnergia() = energiaMagica.obtener()
    method desafiar(oponente, puntosDeEnergia) {
    const puedeVencer = self.poderTotal() > oponente.resistenciaMagica()

    if (puedeVencer) {
        const energiaRobada = puntosDeEnergia.min(oponente.obtenerEnergia())
        oponente.restarEnergia(energiaRobada)
        self.ganarEnergia(energiaRobada)
    }
     return puedeVencer
}
}

class ObjetoMagico {
    method poderAportado(mago){}
}
class Varita inherits ObjetoMagico{
    var poderBase = 0
    method configurarPoderBase(valor) {
        poderBase = valor
    }
   override method poderAportado(mago) {
    const esPar = (mago.nombre().size() / 2) * 2 == mago.nombre().size() // Verifica si es par
    if (esPar) {
         poderBase * 1.5
    } else {
         poderBase
    }
  }
}
class Tunica inherits ObjetoMagico {
    var resistenciaBase = 0 
    method configurarResistenciaBase(valor) {
        resistenciaBase = valor
    }  //method para probar
    override method poderAportado(mago) = resistenciaBase * 2
}

class TunicaEpica inherits Tunica {
    override method poderAportado(mago) = super(mago) + 10 
}
class Amuleto inherits ObjetoMagico {
    override method poderAportado(_mago) = 200 // ya que siempre aporta 200 unidades
}
class Ojota inherits ObjetoMagico {
    override method poderAportado(mago) = mago.nombre().size() * 10
}
class EnergiaMagica {
    var cantidad = 0

    method configurar(valorInicial) {
        cantidad = valorInicial
    }
    method restar(cantidadARestar) {
        cantidad = (cantidad - cantidadARestar).max(0)
    }
    method agregar(cantidadAAgregar) {
        cantidad += cantidadAAgregar
    }
    method obtener() = cantidad
}
class Gremios{
    var miembros = []
  method configurar(miembrosIniciales) {
        if (miembrosIniciales.size() < 2) {
             self.error("Un gremio debe tener al menos dos miembros")
        } else {
            miembros = miembrosIniciales
            return "Gremio configurado exitosamente."
        }
    }
    method poderTotal() = miembros.sum({ miembro => miembro.poderTotal() })
   method resistenciaTotal() {
        const resistenciaMiembros = miembros.sum({ miembro => miembro.resistenciaMagica() })
        return resistenciaMiembros + self.lider().resistenciaMagica() 
    }
    method lider() = miembros.max({ miembro => miembro.poderTotal() })
    method transferirEnergiaAlLider(cantidad) {
        const lider = self.lider()
        lider.ganarEnergia(cantidad)
    }
method desafiar(oponente, puntosDeEnergia) {
    const victoria = self.esVictoria(oponente)
    if (victoria) {
        self.procesarVictoria(oponente, puntosDeEnergia)
    }
    return victoria
}

method esVictoria(oponente) = self.poderTotal() > oponente.resistenciaTotal()
method procesarVictoria(oponente, puntosDeEnergia) {
    const energiaRobada = puntosDeEnergia.min(oponente.obtenerEnergia())
    oponente.restarEnergia(energiaRobada)
    self.transferirEnergiaAlLider(energiaRobada)
 }
}


