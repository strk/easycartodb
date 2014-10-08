all:
	make -C map-api
	make -C sql-api
	make -C rails-app

check:
	make -C sql-api check
	make -C map-api check
	make -C rails-app check
