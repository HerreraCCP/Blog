using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using Blog.Models;
using Dapper;

namespace Blog.Repositories
{
    public class UserRepository : Repository<User>
    {
        private readonly SqlConnection _connection;

        public UserRepository(SqlConnection connection) : base(connection:connection)
            => _connection = connection;

        public List<User> GetWithRoles()
        {
            const string query = @"SELECT U.*, R.*
                          FROM [User] AS U (nolock)
                          LEFT JOIN [UserRole] AS UR (nolock) ON UR.UserId = U.Id
                          LEFT JOIN [Role] AS R (nolock) ON UR.RoleId = R.Id";

            var users = new List<User>();

            var items = _connection.Query<User, Role, User>( //User, Role e o tipo do retorno que é USER
                query,
                (user, role) =>
                {
                    var usr = users.FirstOrDefault(x => x.Id == user.Id); //Verifico se o usuário já existe
                    if (usr == null) // se nao encontrou o usuario na lista, nao passei por este usuario ainda.
                    {
                        usr = user; //o usuario é igual ao usuario que recebi no método acima
                        if (role != null) usr.Roles.Add(role); // se o usuario está vazio nao há role adiciono
                        users.Add(usr); //e adiciono o usuário a lista de user
                    }
                    else
                    {
                        usr.Roles.Add(role); //se ele já existe só adiciono a role.
                    }
                    return user;
                }, splitOn: "Id");
            return users;
        }
    }
}