# Zombie API


## Info
This project(API) purpose is to help on a zombie apocalypse

 - Create new survivors
 - Retrieve a survivor
 - Update a survivor
 - Retrieve closest survivor from a survivor 
 - Mark survivor as infected

 obs* A survivor is marked infected when at least 3 others survivors report that it is infected.

<details>
  <summary>
     Technologies
  </summary>

  - Ruby 3
  - Rails 7
  - PostgreSQL
  - Rubocop(Linter)
  - RSpec(Tests)
  - SimpleCov(Test Coverage)

</details>

<details>
  <summary>
     Initial Setup
  </summary>

Clone project(https or ssh)
```
git clone https://github.com/xitarps/zombie_api
```
or
```
git clone git@github.com:xitarps/zombie_api.git
```

Enter folder
```
cd zombie_api
```
Run Setup
```
./bin/setup.sh
```
 <hr>

Optionaly You can either generate initial data
```
rails db:seed
```
</details>

<details>
  <summary>
     How to Run
  </summary>

Run command
```
rails server
```
</details>

<details>
  <summary>
     Endpoints
  </summary>



Create new survivors
```
POST http://127.0.0.1:3000/api/v1/survivors

body: {
	"survivor": {
		"name": "new_survivor",
		"gender": ""
	}
}
```

Retrieve a survivor
```
GET http://127.0.0.1:3000/api/v1/survivors/:id
```

Update a survivor
```
PUT http://127.0.0.1:3000/api/v1/survivors/:id

body: { 
	"survivor": { 
		"id": "bee438b6-53ba-4f96-9e92-68f3b16fa4f7",
	 	"token": "376167",
    "name": "new_survivor_name",
	 	"gender": "female"
	}
}
```

Retrieve closest survivor from a survivor
```
GET http://127.0.0.1:3000/api/v1/survivors/:id/retrive_closest_survivor
```

Mark survivor as infected
```
POST http://127.0.0.1:3000/api/v1/infections/

body: {
	"infection": {
		"informer": {
			"id": "bee438b6-53ba-4f96-9e92-68f3b16fa4f7",
			"token": "376167"
		},
		"survivor": {
			"id": "7880ae37-c6f4-40eb-a1eb-c104dbba8c24"
		}
	}
}
```

</details>


<details>
  <summary>
     Tests and Linter
  </summary>

how to run tests:
```
rspec
```

how to run linter check:
```
rubocop
```

*obs: After running tests/rspec,
SimpleCov will generate a folder 'coverage' with a coverage report(open inside your browser)
```
coverage/index.html
```

</details>

<details>
  <summary>
     Board(development/github projects)
  </summary>

https://github.com/users/xitarps/projects/2/views/1

</details>

</details>

<details>
  <summary>
     Further Improvements/Features
  </summary>

  - Use docker
  - Use a better algorithm to retrieve closest survivor
  - Add show Survivors list
  - Add Reset token
  - Host Project
  - Maybe use accepts_nested_attributes_for position inside Survivor

</details>
