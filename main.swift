class Category : CustomStringConvertible {
	var name: String
	var tasks: Array<Task>

	init(name: String) {
		self.name = name
		self.tasks = Array()
	}
	
	public var description: String {
	    if tasks.count == 0 {
	        return "\(name) with no task"
	    } else if tasks.count == 1 {
			return "\(name) with 1 task"
		}
	    return "\(name) with \(tasks.count) tasks"
	}
}

class Task : Equatable, CustomStringConvertible  {
	static var idGenerator = 0

	var id: Int
	var title: String
	var content: String
	var priority: Int
	var creationDate: Date
	var category: Category?

	public init(title: String, content: String, priority: Int) {
		self.id = Task.idGenerator
		self.title = title
		self.content = content
		self.priority = priority
		self.creationDate = Date()
		self.category = nil
		Task.idGenerator += 1
	}

	public var description: String {
		let dateformat = DateFormatter()
        dateformat.dateFormat = "EEEE, MMM d, yyyy"
		dateformat.timeZone = TimeZone.current
        let formattedDateDay = dateformat.string(from: creationDate)
		dateformat.dateFormat = "HH:mm:ss"
		let formattedDateHour = dateformat.string(from: creationDate)
		return "\"\(title)\": \"\(content)\" with priority \(priority) created on \(formattedDateDay) at \(formattedDateHour)"
	}

	public static func == (o1: Task, o2: Task) -> Bool{
        return o1.id == o2.id
    }
}