using System;
using Blog.Models;
using Blog.Repositories;
using System.Data.SqlClient;

namespace Blog
{
    public static class Program
    {
        private const string ConnectionString =
            @"Data Source=localhost,1433;Initial Catalog=Blog;User ID=sa;Password=A123456s;TrustServerCertificate=true;";

        private static void Main(string[] args)
        {
            var connection = new SqlConnection(ConnectionString);
            connection.Open();
                // CreateUser(connection); //C 
                // ReadUsers(connection);  //R
                // UpdateUser(connection); //U 
                // DeleteUser(connection); //D 

                //ReadUserWithRoles
                // ReadRoles(connection);
                // ReadTags(connection);
            connection.Close();
        }

        private static void CreateUser(SqlConnection connection)
        {
            var repository = new Repository<User>(connection: connection);
            repository.Create(MyUser("Rodrigo Silva", email: "rodrigo.herrera.ca@gmail.com",
                "Hash", "Future MVP", "slug"));
        }

        private static void ReadUsers(SqlConnection connection)
        {
            var repository = new Repository<User>(connection: connection);
            var users = repository.Get();

            foreach (var user  in users)
            {
                Console.WriteLine($"user => {user.Name}");
            }
        }

        private static void ReadRoles(SqlConnection connection)
        {
            var repository = new Repository<Role>(connection: connection);
            var items = repository.Get();

            foreach (var role  in items)
            {
                Console.WriteLine($"role => {role.Name}");
            }
        }

        private static void ReadTags(SqlConnection connection)
        {
            var repository = new Repository<Tag>(connection: connection);
            var items = repository.Get();

            foreach (var tag in items)
            {
                Console.WriteLine($"Tag => {tag.Name}");
            }
        }

        private static void UpdateUser(SqlConnection connection)
        {
            var user = MyUser("Rodrigo Herrera Silva", email: "rodrigo.herrera.ca@gmail.com",
                "Hash", "I gonna be a MVP", "slug");
            user.Id = 5;

            var repository = new Repository<User>(connection: connection);
            repository.Update(user);
        }

        private static void DeleteUser(SqlConnection connection)
        {
            var repository = new Repository<User>(connection: connection);
            repository.Delete(4);
        }

        private static void ReadUserWithRoles(SqlConnection connection)
        {
            var repository = new UserRepository(connection: connection);
            var items = repository.GetWithRoles();
            foreach (var user in items)
            {
                Console.WriteLine($"{user}");
                foreach (var role in user.Roles)
                {
                    Console.WriteLine($"{role}");
                }
            }
        }

        private static User MyUser(string name, string email,
            string passwordHash, string bio, string slug)
        {
            var user = new User
            {
                Name = name,
                Email = email,
                PasswordHash = passwordHash,
                Bio = bio,
                Slug = slug
            };

            return user;
        }

        private static Role CreateOneRole(string name, string slug)
        {
            var role = new Role
            {
                Name = name,
                Slug = slug
            };
            return role;
        }
    }
}