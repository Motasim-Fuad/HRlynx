class SessionChatModel {
  final bool success;
  final Session session;
  final List<Message> messages;
  final Pagination pagination;

  SessionChatModel({
    required this.success,
    required this.session,
    required this.messages,
    required this.pagination,
  });

  factory SessionChatModel.fromJson(Map<String, dynamic> json) {
    return SessionChatModel(
      success: json['success'],
      session: Session.fromJson(json['session']),
      messages: (json['messages'] as List).map((e) => Message.fromJson(e)).toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}


class Data {
  final Session session;
  final List<Message> messages;
  final Pagination pagination;

  Data({
    required this.session,
    required this.messages,
    required this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      session: Session.fromJson(json['session']),
      messages: (json['messages'] as List).map((e) => Message.fromJson(e)).toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Message {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isSuggestion;

  Message({
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isSuggestion = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}


class Pagination {
  final int page;
  final int pageSize;
  final bool hasMore;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['page_size'],
      hasMore: json['has_more'],
    );
  }
}

class Session {
  final String id;
  final String title;
  final Persona persona;

  Session({
    required this.id,
    required this.title,
    required this.persona,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      title: json['title'],
      persona: Persona.fromJson(json['persona']),
    );
  }
}

class Persona {
  final int id;
  final String name;
  final String title;
  final String avatar;

  Persona({
    required this.id,
    required this.name,
    required this.title,
    required this.avatar,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      avatar: json['avatar'],
    );
  }
}
