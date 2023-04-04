part of manage_calendar_events;

class Calendar {
  String? id;
  String? name;
  String? accountName;
  String? ownerName;
  bool? isReadOnly;
  Calendar({
    this.id,
    this.name,
    this.accountName,
    this.ownerName,
    this.isReadOnly,
  });


  Calendar copyWith({
    String? id,
    String? name,
    String? accountName,
    String? ownerName,
    bool? isReadOnly,
  }) {
    return Calendar(
      id: id ?? this.id,
      name: name ?? this.name,
      accountName: accountName ?? this.accountName,
      ownerName: ownerName ?? this.ownerName,
      isReadOnly: isReadOnly ?? this.isReadOnly,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'accountName': accountName,
      'ownerName': ownerName,
      'isReadOnly': isReadOnly,
    };
  }

  factory Calendar.fromMap(Map<String, dynamic> map) {
    return Calendar(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      accountName: map['accountName'] != null ? map['accountName'] as String : null,
      ownerName: map['ownerName'] != null ? map['ownerName'] as String : null,
      isReadOnly: map['isReadOnly'] != null ? map['isReadOnly'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Calendar.fromJson(String source) => Calendar.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Calendar(id: $id, name: $name, accountName: $accountName, ownerName: $ownerName, isReadOnly: $isReadOnly)';
  }

  @override
  bool operator ==(covariant Calendar other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.accountName == accountName &&
      other.ownerName == ownerName &&
      other.isReadOnly == isReadOnly;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      accountName.hashCode ^
      ownerName.hashCode ^
      isReadOnly.hashCode;
  }
}
