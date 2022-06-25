import 'package:cl3_t6nn_acevedosaldana_jhonalexander/models/servicio_model.dart';
import 'package:cl3_t6nn_acevedosaldana_jhonalexander/pantallas/nuevo_servicio.dart';
import 'package:cl3_t6nn_acevedosaldana_jhonalexander/providers/servicio_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:json_table/json_table.dart';

class listadoVEN_Servicio extends StatefulWidget {
  String titulo;
  final _provider = new VEN_ServicioProvider();
  List<Servicio> oListaVEN_Servicio = [];
  int codigoVEN_ServicioSeleccionado = 0;
  Servicio oServicio = Servicio();
  String jSonVEN_Servicio = "";
  listadoVEN_Servicio(this.titulo);
  @override
  State<StatefulWidget> createState() => _ListadoVEN_Servicio();
}

class _ListadoVEN_Servicio extends State<listadoVEN_Servicio> {
  final _tfNombreCliente = TextEditingController();
  final _tfNumeroOrdenServicio = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    widget.jSonVEN_Servicio = '[${widget.oServicio.toModelString()}]';
  }

  Future<String> _consultarRegistros() async {
    Servicio pServicio = Servicio();
    pServicio.inicializar();
    pServicio.nombreCliente = _tfNombreCliente.text;
    pServicio.numeroOrdenServicio = _tfNumeroOrdenServicio.text;

    var oListaVEN_ServicioTmp = await widget._provider.listar(pServicio);
    // ignore: avoid_print
    print(oListaVEN_ServicioTmp);
    setState(() {
      widget.oListaVEN_Servicio = oListaVEN_ServicioTmp;
      widget.jSonVEN_Servicio = widget._provider.jsonResultado;
      if (widget.oListaVEN_Servicio.length == 0) {
        widget.jSonVEN_Servicio = '[${widget.oServicio.toModelString()}]';
      }
    });
    return "Procesado";
  }

  void _nuevoRegistro() {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Servicio("", 0);
    }));
  }

  void _verRegistro(int pCodigoServicio) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Servicio("", pCodigoServicio);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(widget.jSonVEN_Servicio);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Consulta de Servicios "),
          actions: [
            IconButton(
                icon: const Icon(Icons.search), onPressed: _consultarRegistros),
            IconButton(
                icon: const Icon(Icons.assignment_outlined),
                onPressed: _nuevoRegistro),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Para consultar completar el nombre del cliente y dar click en consultar",
                style: TextStyle(fontSize: 12),
              ),
              TextField(
                  controller: _tfNombreCliente,
                  decoration: const InputDecoration(
                    hintText: "Ingrese Nombre del Cliente ",
                    labelText: "Cliente",
                  )),
              TextField(
                  controller: _tfNumeroOrdenServicio,
                  decoration: const InputDecoration(
                    hintText: "Ingrese Código de Orden ",
                    labelText: "Código de Orden",
                  )),
              Text(
                "Se encontraron " +
                    widget.oListaVEN_Servicio.length.toString() +
                    " Servicios",
                style: const TextStyle(fontSize: 9),
              ),
              JsonTable(
                json,
                columns: [
                  JsonTableColumn("CodigoServicio", label: "Código"),
                  JsonTableColumn("NombreCliente", label: "Nombre del Cliente"),
                  JsonTableColumn("NumeroOrdenServicio", label: "Numero Orden Servicio"),
                  JsonTableColumn("FechaProgramada", label: "Fecha Programada"),
                  JsonTableColumn("Linea", label: "Linea"),
                  JsonTableColumn("Estado", label: "Estado"),
                  JsonTableColumn("Observaciones", label: "Observaciones"),
                ],
                showColumnToggle: false,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500]!.withOpacity(0.7),
                paginationRowCount: 10,
                onRowSelect: (index, map) {
                  _verRegistro(int.parse(map["CodigoServicio"].toString()));
                },
              ),
            ],
          ),
        ));
  }
}
