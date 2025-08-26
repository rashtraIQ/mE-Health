struct ImmunizationModel : Codable , Equatable{
    let entry : [ImmunizationEntry]?

    enum CodingKeys: String, CodingKey {

        case entry = "entry"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        entry = try values.decodeIfPresent([ImmunizationEntry].self, forKey: .entry)
    }

}


struct ImmunizationEntry : Codable,Equatable {
    let resource : ImmunizationResource?

    enum CodingKeys: String, CodingKey {

        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resource = try values.decodeIfPresent(ImmunizationResource.self, forKey: .resource)
    }

}

struct ImmunizationResource : Codable,Equatable {
    let resourceType : String?
    let id : String?
    let identifier : [Identifier]?
    let status : String?
    let vaccineCode : VaccineCode?
    //let patient : PatientReference?
    let encounter : Encounter?
    let occurrenceDateTime : String?
    let primarySource : Bool?
    let location : Location?
    let manufacturer : Manufacturer?
    let lotNumber : String?
    let site : Site?
    let route : Route?
    let doseQuantity : DoseQuantity?
    let performer : [Performer]?

    enum CodingKeys: String, CodingKey {

        case resourceType = "resourceType"
        case id = "id"
        case identifier = "identifier"
        case status = "status"
        case vaccineCode = "vaccineCode"
       // case patient = "patient"
        case encounter = "encounter"
        case occurrenceDateTime = "occurrenceDateTime"
        case primarySource = "primarySource"
        case location = "location"
        case manufacturer = "manufacturer"
        case lotNumber = "lotNumber"
        case site = "site"
        case route = "route"
        case doseQuantity = "doseQuantity"
        case performer = "performer"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceType = try values.decodeIfPresent(String.self, forKey: .resourceType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        identifier = try values.decodeIfPresent([Identifier].self, forKey: .identifier)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        vaccineCode = try values.decodeIfPresent(VaccineCode.self, forKey: .vaccineCode)
       // patient = try values.decodeIfPresent(PatientReference.self, forKey: .patient)
        encounter = try values.decodeIfPresent(Encounter.self, forKey: .encounter)
        occurrenceDateTime = try values.decodeIfPresent(String.self, forKey: .occurrenceDateTime)
        primarySource = try values.decodeIfPresent(Bool.self, forKey: .primarySource)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
        manufacturer = try values.decodeIfPresent(Manufacturer.self, forKey: .manufacturer)
        lotNumber = try values.decodeIfPresent(String.self, forKey: .lotNumber)
        site = try values.decodeIfPresent(Site.self, forKey: .site)
        route = try values.decodeIfPresent(Route.self, forKey: .route)
        doseQuantity = try values.decodeIfPresent(DoseQuantity.self, forKey: .doseQuantity)
        performer = try values.decodeIfPresent([Performer].self, forKey: .performer)
    }

}

struct Manufacturer : Codable , Equatable{
    let display : String?

    enum CodingKeys: String, CodingKey {

        case display = "display"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }

}

struct Site : Codable , Equatable{
    let coding : [Coding]?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}

struct Route : Codable, Equatable {
    let coding : [Coding]?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}

struct VaccineCode : Codable,Equatable {
    let coding : [Coding]?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}

struct Location : Codable , Equatable{
    let display : String?

    enum CodingKeys: String, CodingKey {

        case display = "display"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        display = try values.decodeIfPresent(String.self, forKey: .display)
    }

}

struct Performer : Codable , Equatable{
    let function : Function?
    let actor : Actor?

    enum CodingKeys: String, CodingKey {

        case function = "function"
        case actor = "actor"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        function = try values.decodeIfPresent(Function.self, forKey: .function)
        actor = try values.decodeIfPresent(Actor.self, forKey: .actor)
    }

}

struct Function : Codable , Equatable{
    let coding : [Coding]?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case coding = "coding"
        case text = "text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coding = try values.decodeIfPresent([Coding].self, forKey: .coding)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}
