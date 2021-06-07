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