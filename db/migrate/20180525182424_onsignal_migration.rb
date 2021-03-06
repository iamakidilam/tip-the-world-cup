class OnsignalMigration < ActiveRecord::Migration[5.2]
    def change
        create_table :devices do |t|

            t.references :owner, polymorphic: true, index: true

            t.string :onesignal_id, index: true, unique: true
            t.string :onesignal_permission

            t.datetime :last_used

            t.timestamps

        end
    end
end
