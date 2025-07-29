### Prerequisites
  * **Ruby**: Version 3.3.x
  * **Rails**: Version 7.2.x

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/pusanisajarusiripat/bulk-create-charge.git
    cd bulk-create-charge
    ```
2. **Environment Variables**

    Create a `.env` file in the project root with the following content:

    ```
    BULK_AUTH_USER=authuser
    BULK_AUTH_PASSWORD=yoursecret
    VAULT_URL=https://sample.api.vault.co
    URL=https://sample.api.url.co
    P_KEY=pk_test_1234567890
    S_KEY=sk_test_1234567890
    ```

3.  **Install dependencies:**

    ```bash
    bundle install
    ```

4.  **Set up the database:**

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

5.  **Start the Rails server:**

    ```bash
    rails s
    ```

    The application should now be accessible at `http://localhost:3000`.

## Tools & Libraries

  * **Sidekiq**: Used for efficient background job processing.
  * **Minitest**: The testing framework for unit tests.
  * **Fabrication**: A library for creating test data (fixtures/factories) in tests.