class Chef::Recipe::Kerberos

  def self.create_user(chef, username, password)
    chef.bash "kerberos.create_user #{username}" do
      user 'root'
      cwd '/tmp'
      code <<-EOF
echo "delprinc #{username}
yes" | kadmin.local

echo "addprinc -pw #{password} #{username}" | kadmin.local
      EOF
      not_if { %x(echo listprincs | kadmin.local | grep #{username}@ | wc -l).to_i > 0 }
    end
  end

  def self.delete_user(chef, username)
    chef.bash "kerberos.delete_user #{username}" do
      user 'root'
      cwd '/tmp'
      code <<-EOF
echo "delprinc #{username}
yes" | kadmin.local
      EOF
      not_if { %x(echo listprincs | kadmin.local | grep #{username}@ | wc -l).to_i == 0 }
    end
  end

end
