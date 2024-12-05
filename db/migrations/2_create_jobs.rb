Sequel.migration do
  up do
    create_table(:jobs) do
      primary_key :id
      DateTime :created_at, null: false, default: Time.now
      String :state, size: 20, null: false, default: 'pending'
      String :payload, text: true
      String :result, text: true
    end
  end

  down do
    drop_table(:jobs)
  end
end
