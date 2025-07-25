### Prerequisites
  * **Ruby**: Version 3.3.x
  * **Rails**: Version 7.2.x

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/pusanisajarusiripat/bulk-create-charge.git
    cd bulk-create-charge
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Set up the database:**

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4.  **Start the Rails server:**

    ```bash
    rails s
    ```

    The application should now be accessible at `http://localhost:3000`.

## Tools & Libraries

  * **Sidekiq**: Used for efficient background job processing.
  * **Minitest**: The testing framework for unit tests.
  * **Fabrication**: A library for creating test data (fixtures/factories) in tests.

