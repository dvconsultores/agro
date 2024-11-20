import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sap_avicola/models/equipos_model.dart';
import 'package:sap_avicola/models/galpon_model.dart';
import 'package:sap_avicola/models/galpon_recepcion_model.dart';
import 'package:sap_avicola/models/granja_model.dart';
import 'package:sap_avicola/models/incubadora_model.dart';
import 'package:sap_avicola/models/kpis_home_model.dart';
import 'package:sap_avicola/models/kpis_statistics_model.dart';
import 'package:sap_avicola/models/lote_huevos_recepcion_model.dart';
import 'package:sap_avicola/models/lote_incubadora_model.dart';
import 'package:sap_avicola/models/lote_model.dart';
import 'package:sap_avicola/models/lote_salida_aprobada_model.dart';
import 'package:sap_avicola/models/lote_salida_model.dart';
import 'package:sap_avicola/models/orden_alimento_model.dart';
import 'package:sap_avicola/models/orden_salida_aves_model.dart';
import 'package:sap_avicola/models/orden_salida_pollitos_model.dart';
import 'package:sap_avicola/models/ordene_recepcion_cria_model.dart';
import 'package:sap_avicola/models/planta_beneficio_model.dart';
import 'package:sap_avicola/models/proveedores_model.dart';
import 'package:sap_avicola/models/razas_model.dart';
import 'package:sap_avicola/models/rol_user_model.dart';
import 'package:sap_avicola/models/semana_model.dart';
import 'package:sap_avicola/models/tipo_alimento_model.dart';
import 'package:sap_avicola/models/transporte_model.dart';
import 'package:sap_avicola/models/vacuna_model.dart';
import 'package:sap_avicola/utils/services/dio_service.dart';

class ApiLiderPollo {
  Future<List<RolUserModel>> getRolUser() async {
    try {
      final response = await dio.get('/consult_users/get-rol-user');

      return RolUserModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<GranjaModel>> getGranjas() async {
    try {
      final response = await dio.get('/consult_granjas/get-granjas');

      return GranjaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<PlantaBeneficioModel>> getPlantasBeneficio() async {
    try {
      final response = await dio.get('/consult_granjas/get-plantas-beneficio');

      return PlantaBeneficioModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<GalponModel>> getGalpones(granjaId) async {
    try {
      final response = await dio.get("/consult_granjas/get-galpones/$granjaId");

      return GalponModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<EquiposModel>> getEquipos(granjaId) async {
    try {
      final response = await dio.get("/consult_granjas/get-equipos/$granjaId");

      return EquiposModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<ProveedorModel>> getProveedores() async {
    try {
      final response = await dio.get("/consult_granjas/get-proveedores");

      return ProveedorModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<RazasModel>> getRazas() async {
    try {
      final response = await dio.get("/consult_granjas/get-razas");

      return RazasModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<TipoAlimentoModel>> getTipoAlimento() async {
    try {
      final response = await dio.get("/consult_granjas/get-tipo-alimento");

      return TipoAlimentoModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<TransporteModel>> getTransportes() async {
    try {
      final response = await dio.get("/consult_granjas/get-transportes");

      return TransporteModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<VacunaModel>> getVacunas() async {
    try {
      final response = await dio.get("/consult_granjas/get-vacunas");

      return VacunaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setInspeccionGranja(data) async {
    try {
      await dio.post("/granjas/set-inspeccion-granja/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteModel>> getLotesRecepcion(granjaId, etapa) async {
    try {
      final response = await dio
          .get("/consult_granjas/get-lotes-recepcion/$granjaId/$etapa");

      return LoteModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<GalponRecepcionModel>> getGalponesRecepcion(
      recepcionId, etapa) async {
    try {
      final response = await dio
          .get("/consult_granjas/get-galpones-recepcion/$recepcionId/$etapa");
      return GalponRecepcionModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<OrdenSalidaAvesModel>> getOrdenesSalida(granjaId, etapa) async {
    try {
      final response =
          await dio.get("/consult_granjas/get-ordenes-salida/$granjaId/$etapa");
      return OrdenSalidaAvesModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteSalidaModel>> getLotesSalida(granjaId, etapa) async {
    try {
      final response =
          await dio.get("/consult_granjas/get-lotes-salida/$granjaId/$etapa");
      return LoteSalidaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<OrdenAlimentoModel>> getOrdenesAlimento(granjaId, etapa) async {
    try {
      final response = await dio
          .get("/consult_granjas/get-ordenes-alimento/$granjaId/$etapa");
      return OrdenAlimentoModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setAlimento(data, etapa) async {
    try {
      final dataFinal = {
        "data": data,
        "etapa": etapa,
      };
      await dio.post("/granjas/set-alimento/", data: dataFinal);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setPesaje(data, etapa) async {
    try {
      final dataFinal = {
        "data": data,
        "etapa": etapa,
      };
      await dio.post("/granjas/set-pesaje/", data: dataFinal);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setMortalidad(data, etapa) async {
    try {
      final dataFinal = {
        "data": data,
        "etapa": etapa,
      };
      await dio.post("/granjas/set-mortalidad/", data: dataFinal);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setVacuna(data, etapa) async {
    try {
      final dataFinal = {
        "data": data,
        "etapa": etapa,
      };
      await dio.post("/granjas/set-vacuna/", data: dataFinal);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<SemanaModel>> getSemanasLote(recepcionId, etapa) async {
    try {
      final response = await dio
          .get("/consult_granjas/get-semanas-lote/$recepcionId/$etapa");

      return SemanaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<KpisStatisticModel>> getKpisLote(
      recepcionId, semana, etapa) async {
    try {
      final dataFinal = {
        "recepcionId": recepcionId,
        "semana": semana,
        "etapa": etapa
      };

      final response =
          await dio.post("/consult_granjas/get-kpis-lote/", data: dataFinal);

      return KpisStatisticModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<KpisHomeModel> getKpisHome(etapa) async {
    try {
      final response = await dio.get("/consult_granjas/get-kpis-home/$etapa");

      return KpisHomeModel.fromJson(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  ///////////////////////////// etapa cria  ///////////////////////////
  Future<List<OrdenRecepcionCriaModel>> getOrdenesRecepcionCrias(
      granjaId) async {
    try {
      final response =
          await dio.get("/consult_granja_cria/get-ordenes-recepcion/$granjaId");

      return OrdenRecepcionCriaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteModel>> getCriaLotesDisponibles() async {
    try {
      final response =
          await dio.get("/consult_granja_cria/get-lotes-disponibles");

      return LoteModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setRecepcionCrias(data) async {
    try {
      await dio.post("/granja_cria/set-recepcion/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setSalidaAvesCrias(data) async {
    try {
      await dio.post("/granja_cria/set-salida-aves/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setInspeccionTransporteCrias(data) async {
    try {
      await dio.post("/granja_cria/set-inspeccion-transporte/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  ///////////////////////////  etapa produccion  //////////////////////
  Future<List<LoteHuevosRecepcionModel>> getLotesHuevosRecepcion(
      granjaId) async {
    try {
      final response = await dio.get(
          "/consult_granja_produccion/get-lotes-huevos-recepcion/$granjaId");

      return LoteHuevosRecepcionModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteSalidaModel>> getLotesSalidaAprobadaProduccion(
      granjaId) async {
    try {
      final response = await dio.get(
          "/consult_granja_produccion/get-lotes-salida-aprobada/$granjaId");

      return LoteSalidaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setRecepcionProduccion(data) async {
    try {
      await dio.post("/granja_produccion/set-recepcion/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setSalidaAvesProduccion(data) async {
    try {
      await dio.post("/granja_produccion/set-salida-aves/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteHuevosRecepcionModel>> getLotesSalidaHuevosProduccion(
      granjaId) async {
    try {
      final response = await dio
          .get("/consult_granja_produccion/get-lotes-salida-huevos/$granjaId");

      return LoteHuevosRecepcionModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setInspeccionTransporteProduccion(data) async {
    try {
      await dio.post("/granja_produccion/set-inspeccion-transporte/",
          data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setInspeccionTransporteHuevosProduccion(data) async {
    try {
      await dio.post("/granja_produccion/set-inspeccion-transporte-huevos/",
          data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setRecoleccionHuevosProduccion(data) async {
    try {
      await dio.post("/granja_produccion/set-recoleccion-huevos/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setSalidaHuevosProduccion(data) async {
    try {
      await dio.post("/granja_produccion/set-salida-huevos/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  ///////////////////////////  incubadoras  //////////////////////////////

  Future<List<IncubadoraModel>> getIncubadoras() async {
    try {
      final response = await dio.get('/consult_incubadoras/get-incubadoras');

      return IncubadoraModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setInspeccionIncubadora(data) async {
    try {
      await dio.post("/incubadora/set-inspeccion-incubadora/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteHuevosRecepcionModel>> getLotesHuevosRecepcionar(
      granjaId) async {
    try {
      final response = await dio
          .get('/consult_incubadoras/get-lotes-salida-huevos/$granjaId');

      return LoteHuevosRecepcionModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteIncubadoraModel>> getLotesRecepcionIncubadora(
      granjaId, status) async {
    try {
      final response = await dio
          .get('/consult_incubadoras/get-lotes-recepcion/$granjaId/$status');
      return LoteIncubadoraModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<OrdenSalidaPollitosModel>> getOrdenesSalidaIncubadora() async {
    try {
      final response = await dio.get('/consult_incubadoras/get-ordenes-salida');

      return OrdenSalidaPollitosModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<SemanaModel>> getSemanasIncubadora() async {
    try {
      final response =
          await dio.get("/consult_incubadoras/get-semanas-incubadora");

      return SemanaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<KpisStatisticModel>> getKpisIncubadora(semana) async {
    try {
      final response =
          await dio.get("/consult_incubadoras/get-kpis-diario/$semana");

      return KpisStatisticModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setRecepcionIncubadora(data) async {
    try {
      await dio.post("/incubadora/set-recepcion/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setClasificacionIncubadora(data) async {
    try {
      await dio.post("/incubadora/set-clasificacion/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setIncubacionIncubadora(data) async {
    try {
      await dio.post("/incubadora/set-incubacion/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setNacimientoIncubadora(data) async {
    try {
      await dio.post("/incubadora/set-nacimiento/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setSalidaPollitosIncubadora(data) async {
    try {
      await dio.post("/incubadora/set-salida-pollitos/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  //////////////////////////////  engorde  //////////////////////////////
  Future<List<LoteModel>> getEngordeLotesDisponibles() async {
    try {
      final response =
          await dio.get("/consult_granja_engorde/get-lotes-disponibles");

      return LoteModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<List<LoteSalidaAprobadaModel>> getLotesSalidaAprobadaEngorde(
      granjaId) async {
    try {
      final response = await dio
          .get("/consult_granja_engorde/get-lotes-salida-aprobada/$granjaId");

      return LoteSalidaAprobadaModel.buildListFrom(response.data);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setRecepcionEngorde(data) async {
    try {
      await dio.post("/granja_engorde/set-recepcion/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setSalidaAvesEngorde(data) async {
    try {
      await dio.post("/granja_engorde/set-salida-aves/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<bool> setInspeccionTransporteEngorde(data) async {
    try {
      await dio.post("/granja_engorde/set-inspeccion-transporte/", data: data);

      return true;
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  /*Future<void> createOffer({
    required String typeOffer,
    required int ownerId,
    required int assetId,
    required double amount,
    required double minAmount,
    required double maxAmount,
    required int fiatId,
    required String termConditions,
    required String autoMessage,
    required int durationTime,
    List<int>? paymentMethods,
    required List<Map<String, dynamic>> paymentMethodsUser,
    required double price,
    required bool automaticRate,
  }) async {
    try {
      await dio.post('offer/createoffer', data: {
        "dataoffer": {
          "typeOffer": typeOffer,
          "ownerId": ownerId,
          "assetId": assetId,
          "amount": amount,
          "minAmount": minAmount,
          "maxAmount": maxAmount,
          "fiatId": fiatId,
          "termConditions": termConditions,
          "autoMessage": autoMessage,
          "durationTime": durationTime,
          "paymentMethods": paymentMethods,
          "paymentMethodsUser": paymentMethodsUser,
          "automatic_rate": automaticRate,
          "exchangeRate": automaticRate ? price : 0,
          "price": automaticRate ? 0 : price,
        }
      });
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<int> createPreOrder({
    required int offerId,
    required int userId,
    OfferTransactionType? transactionType,
  }) async {
    final data = {
      "offerid": offerId,
      "userid": userId.toString(),
    };

    if (transactionType != null) {
      data['typeTransaction'] = transactionType.value;
    }

    try {
      final response = await dio.post('order/preorder', data: data);

      return response.data["data"];
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }

  Future<OfferModel> getOffer(int offerId) async {
    try {
      final response =
          await dio.post('consult/getoffer/', data: {"offerid": offerId});

      return OfferModel.fromJson(response.data["data"]);
    } on DioException catch (error) {
      throw error.catchErrorMessage();
    }
  }*/
}
