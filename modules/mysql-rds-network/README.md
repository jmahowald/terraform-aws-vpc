Simple terraform project to create a security group for 
RDS (mysql only now)

Normally I'd put this with an actual RDS instance
but because database identities can't be done as variables
and there might be multiple instances, we pulled this out
to it's own module