# Voting App

This is a full-stack Rails + React (Vite) application where users can vote for their favorite performers at a local music festival. Built as an interview exercise, this project supports write-in candidates, fuzzy matching, and real-time results — all wrapped in a clean architecture with service objects and tests.

---

## Tech Stack

- Ruby 3.1.2
- Rails 7.2.1 (See the reason for using Rails 7.2.1 [here](#some-issues-i-ran-into))
- React 18 with Vite
- SQLite3
- Tailwind CSS
- RSpec + FactoryBot + Faker + Shoulda Matchers
- [`amatch`](https://github.com/flori/amatch) for fuzzy string matching

---

## Getting Started

### Prerequisites

- Ruby 3.1.2
- Rails 7.2.1
- Node.js 23.11.0
- Yarn 1.22.19
- Bundler
- SQLite3
- Git
- Coffee (optional, but recommended for development)

---

### Backend Setup

```bash
bundle install
bundle exec rails db:setup
```

### Frontend Setup

```bash
cd frontend
yarn install
```

---

### Running the App

**Start Rails API:**

```bash
bundle exec rails server
```

**Start Vite + React frontend:**

```bash
cd frontend
yarn dev
```

**Run both servers together.**
There's a convenient script to run both Rails and Vite in development mode:

```bash
# This will run both Rails and Vite in development mode
bin/dev
```

Visit: [http://localhost:3001](http://localhost:3001)

---

## Authentication

This app uses simulated login via:

- Email
- Password (not verified)
- ZIP Code

Credentials are stored in session. Secure auth is out of scope for this exercise.

---

## Voting Rules

- Each user can vote **once**
- A user may write in **one candidate**
- Adding a write-in also casts a vote
- There is a max of **10 unique candidates**
- If the submitted name is similar to an existing one (based on Jaro-Winkler), it is matched to that candidate

---

## Results Dashboard

Unauthenticated endpoint:

```
GET /api/v1/results
```

Returns all candidates sorted by vote count (descending), including those with 0 votes.

---

## Running Tests

RSpec powers the test suite. To run:

```bash
# Run full test suite
bundle exec rspec

# Run specific file
bundle exec rspec spec/requests/api/v1/votes_controller_spec.rb

# Run a line
bundle exec rspec spec/services/voting/cast_vote_service_spec.rb:42
```

---

## Design Decisions

- **Service Objects**: All business logic is encapsulated under `app/services`, e.g. `CastVoteService`, `LoginService`, `ResultsFetcher`.
- **UUIDs**: All primary keys use UUIDs for consistency across environments.
- **Fuzzy Matching**: Uses `Amatch::JaroWinkler` with a `SIMILARITY_THRESHOLD` of `0.9` to help users find close matches.
- **Accessibility**: Components and layout strive to meet WCAG basics — focus states, semantic markup, labels, etc.
- **Clean Architecture**: Models are lean. Logic lives in PORO service objects. Specs are SOLID.

---

## API Endpoints

| Method | Path              | Description                 |
| ------ | ----------------- | --------------------------- |
| POST   | `/api/v1/login`   | Logs in or registers a user |
| DELETE | `/api/v1/logout`  | Logs the user out           |
| POST   | `/api/v1/vote`    | Casts or writes in a vote   |
| GET    | `/api/v1/results` | Public results dashboard    |

All POSTs expect `application/json` and use Rails session-based auth.

---

## Debugging

Add `binding.pry` to any Ruby file:

```ruby
def create
  binding.pry
  ...
end
```

Or `console.log()` in React. Rails and Vite both support hot reloads.

---

## Extra Credit Implemented

- Full RSpec test coverage
- Write-in fuzzy name matching
- Accessibility consideration (WCAG)
- Deployable via Vite & Rails (with NGINX or similar)

---

## Thanks

Thanks for reviewing this submission! If you have any questions, feel free to reach out. I had a blast building this

# Some issues I ran into:

- **Rails version compatibility**: I had to use Rails 7.2.1 due to some dependencies that started to crash with 7.0.3. This issue began with ActiveRecord uses concurrent-ruby 1.0 and caused problems when running rails commands. I don't have the exact reason why, but upgrading to 7.2.1 resolved it.
- **Fuzzy matching**: Implementing the fuzzy matching logic with `amatch` was straightforward, but I had to ensure that the threshold was set correctly to avoid false positives. The Jaro-Winkler algorithm worked well for this use case.
- **Testing**: Ensuring that all edge cases were covered in the tests took some time, especially with the fuzzy matching logic. I had to create various scenarios to ensure that the service behaved correctly when casting votes, especially with write-in candidates and similar names.
- **Session management**: I had to implement a simple session management system to handle user authentication and ensure that votes were tied to the correct user. This was done using Rails' built-in session management, which worked well for this exercise.
