// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Enter your name:`
  String get enter_your_name {
    return Intl.message(
      'Enter your name:',
      name: 'enter_your_name',
      desc: '',
      args: [],
    );
  }

  /// `GOGO`
  String get login {
    return Intl.message(
      'GOGO',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Oops!`
  String get empty_name_title {
    return Intl.message(
      'Oops!',
      name: 'empty_name_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name before play game`
  String get empty_name_message {
    return Intl.message(
      'Enter your name before play game',
      name: 'empty_name_message',
      desc: '',
      args: [],
    );
  }

  /// `Find player`
  String get find_player {
    return Intl.message(
      'Find player',
      name: 'find_player',
      desc: '',
      args: [],
    );
  }

  /// `Discovering`
  String get discovering {
    return Intl.message(
      'Discovering',
      name: 'discovering',
      desc: '',
      args: [],
    );
  }

  /// `Connect with nearby player`
  String get connect_with_nearby_player {
    return Intl.message(
      'Connect with nearby player',
      name: 'connect_with_nearby_player',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message(
      'Connect',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Connecting`
  String get connecting {
    return Intl.message(
      'Connecting',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message(
      'Disconnect',
      name: 'disconnect',
      desc: '',
      args: [],
    );
  }

  /// `Start Game`
  String get start_game {
    return Intl.message(
      'Start Game',
      name: 'start_game',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Token`
  String get token {
    return Intl.message(
      'Token',
      name: 'token',
      desc: '',
      args: [],
    );
  }

  /// `Accept connection`
  String get accept_connection {
    return Intl.message(
      'Accept connection',
      name: 'accept_connection',
      desc: '',
      args: [],
    );
  }

  /// `Reject connection`
  String get reject_connection {
    return Intl.message(
      'Reject connection',
      name: 'reject_connection',
      desc: '',
      args: [],
    );
  }

  /// `Map size`
  String get map_size {
    return Intl.message(
      'Map size',
      name: 'map_size',
      desc: '',
      args: [],
    );
  }

  /// `Set the map size to:`
  String get set_map_size_to {
    return Intl.message(
      'Set the map size to:',
      name: 'set_map_size_to',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Game invitation`
  String get game_invitation_title {
    return Intl.message(
      'Game invitation',
      name: 'game_invitation_title',
      desc: '',
      args: [],
    );
  }

  /// `send you a game invite`
  String get game_invitation_message {
    return Intl.message(
      'send you a game invite',
      name: 'game_invitation_message',
      desc: '',
      args: [],
    );
  }

  /// `Denice`
  String get denice {
    return Intl.message(
      'Denice',
      name: 'denice',
      desc: '',
      args: [],
    );
  }

  /// `Play`
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: '',
      args: [],
    );
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `reject connect with you`
  String get reject_connect_with_you {
    return Intl.message(
      'reject connect with you',
      name: 'reject_connect_with_you',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Opponent`
  String get opponent {
    return Intl.message(
      'Opponent',
      name: 'opponent',
      desc: '',
      args: [],
    );
  }

  /// `Your turn`
  String get your_turn {
    return Intl.message(
      'Your turn',
      name: 'your_turn',
      desc: '',
      args: [],
    );
  }

  /// `Opponent turn`
  String get opponent_turn {
    return Intl.message(
      'Opponent turn',
      name: 'opponent_turn',
      desc: '',
      args: [],
    );
  }

  /// `Scroll to opponent's move`
  String get scroll_to_opponent_s_move {
    return Intl.message(
      'Scroll to opponent\'s move',
      name: 'scroll_to_opponent_s_move',
      desc: '',
      args: [],
    );
  }

  /// `Music volume`
  String get music_volume {
    return Intl.message(
      'Music volume',
      name: 'music_volume',
      desc: '',
      args: [],
    );
  }

  /// `Sound effect`
  String get sound_effect {
    return Intl.message(
      'Sound effect',
      name: 'sound_effect',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for`
  String get waiting_for {
    return Intl.message(
      'Waiting for',
      name: 'waiting_for',
      desc: '',
      args: [],
    );
  }

  /// `to accept game invitation`
  String get waiting_accept_invitation {
    return Intl.message(
      'to accept game invitation',
      name: 'waiting_accept_invitation',
      desc: '',
      args: [],
    );
  }

  /// `Play again`
  String get play_again {
    return Intl.message(
      'Play again',
      name: 'play_again',
      desc: '',
      args: [],
    );
  }

  /// `Exit room`
  String get exit_room_title {
    return Intl.message(
      'Exit room',
      name: 'exit_room_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit this room and end the match`
  String get exit_room_message {
    return Intl.message(
      'Do you want to exit this room and end the match',
      name: 'exit_room_message',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Opponent exit`
  String get opponent_exit_title {
    return Intl.message(
      'Opponent exit',
      name: 'opponent_exit_title',
      desc: '',
      args: [],
    );
  }

  /// `has left the room`
  String get opponent_exit_message {
    return Intl.message(
      'has left the room',
      name: 'opponent_exit_message',
      desc: '',
      args: [],
    );
  }

  /// `has lost connection with you`
  String get disconnected_message {
    return Intl.message(
      'has lost connection with you',
      name: 'disconnected_message',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Rematch`
  String get rematch_title {
    return Intl.message(
      'Rematch',
      name: 'rematch_title',
      desc: '',
      args: [],
    );
  }

  /// `is ready for the new game!`
  String get rematch_message {
    return Intl.message(
      'is ready for the new game!',
      name: 'rematch_message',
      desc: '',
      args: [],
    );
  }

  /// `Reject Invitation`
  String get reject_invitation_title {
    return Intl.message(
      'Reject Invitation',
      name: 'reject_invitation_title',
      desc: '',
      args: [],
    );
  }

  /// `declined your invitation to play the game`
  String get reject_invitation_message {
    return Intl.message(
      'declined your invitation to play the game',
      name: 'reject_invitation_message',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}