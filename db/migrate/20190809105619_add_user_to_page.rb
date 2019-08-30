class AddUserToPage < ActiveRecord::Migration[5.2]
  def change
    add_reference :pages, :user, foreign_key: true

    execute <<-SQL
    UPDATE pages SET
      user_id = sites.user_id
    FROM sites
      WHERE sites.id = pages.site_id
    SQL


    #Below triggers a rake task located in the lib directory to create missing user relationships with pages
    # Rake::Task['db:build:create_relationship'].invoke
  end
end
