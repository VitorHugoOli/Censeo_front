import 'dart:async';

import 'package:censeo/src/Professor/Suggestions/models/Categories.dart';
import 'package:censeo/src/Professor/Suggestions/models/Suggestion.dart';
import 'package:censeo/src/Professor/Suggestions/models/Topicos.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../provider.dart';

class Bloc extends Object implements BaseBloc {
  Bloc() {
    fetchCategories();
  }

  final provider = ClassesProvider();
  final _categoriesController =
      BehaviorSubject<Map<String, List<Categories>>>();
  final _topicosController = BehaviorSubject<List<Topicos>>();
  final _suggestionController = BehaviorSubject<List<Suggestion>>();

  Function(List<Suggestion>) get suggestionChanged =>
      _suggestionController.sink.add;

  Stream<List<Suggestion>> get suggestionList => _suggestionController.stream;

  Function(List<Topicos>) get topicosChanged => _topicosController.sink.add;

  Stream<List<Topicos>> get topicosList => _topicosController.stream;

  Function(Map<String, List<Categories>>) get categoriesChanged =>
      _categoriesController.sink.add;

  Stream<Map<String, List<Categories>>> get categoriesList =>
      _categoriesController.stream;

  fetchCategories() async {
    Map<String, List<Categories>> categories = Map<String, List<Categories>>();
    try {
      final Map categoriesReceived =
          await provider.fetchSuggestionsCategories();
      categories = categoriesFromJson(categoriesReceived);
    } catch (ex) {
      debugPrint("Exception Convert Object $ex");
    }
    _categoriesController.sink.add(categories);
  }

  fetchTopicos(id, String type) async {
    List<Topicos> topicos = <Topicos>[];
    try {
      List categoriesReceived;
      categoriesReceived = await provider.fetchTopicos(id, type);
      topicos = topicosFromJson(categoriesReceived);
    } catch (ex) {
      debugPrint("Exception Convert Object $ex");
    }
    topicosChanged(topicos);
  }

  fetchSuggestion(id, String type) async {
    List<Suggestion> suggestions = <Suggestion>[];
    try {
      List categoriesReceived;
      categoriesReceived = await provider.fetchSugestoes(id, type);
      print(categoriesReceived);
      suggestions = sugestaoFromJson(categoriesReceived);
    } catch (ex) {
      debugPrint("Exception Convert Object $ex");
    }
    suggestionChanged(suggestions);
  }

  changeTopicosValue(value, index) {
    List<Topicos> listTemp = _topicosController.value;
    listTemp[index] = Topicos(id: listTemp[index].id, topico: value);
    topicosChanged(listTemp);
  }

  removeTopicosValue(index, id, type) async {
    List<Topicos> listTemp = _topicosController.value;
    if (id >=0) {
      var response = await provider.deleteTopicos(id, type);
      if (response['status']) {
        listTemp.removeAt(index);
      }
    } else {
      listTemp.removeAt(index);
    }
    topicosChanged(listTemp);
  }

  addTopicosValue() {
    List<Topicos> listTemp = _topicosController.value;
    listTemp.add(Topicos(id: -1, topico: ''));
    topicosChanged(listTemp);
  }

  submitTopicos(id, String type) async {
    try {
      var body = _topicosController.value;
      print(body);
      await provider.putTopicos(id, body, type);
      //Todo: Otimizar o retorno do put para retornar a lista e já atualizar
      await fetchTopicos(id, type);
    } catch (ex) {
      debugPrint("Exception Convert Object $ex");
    }
  }

  @override
  void dispose() {
    _categoriesController.close();
    _topicosController.close();
    _suggestionController.close();
  }
}

abstract class BaseBloc {
  void dispose();
}
