docker build --no-cache -t olumayor99/sre-frontend app/frontend/
docker build --no-cache -t olumayor99/sre-backend app/backend/

# docker build -t olumayor99/sre-frontend app/frontend/
# docker build -t olumayor99/sre-backend app/backend/

docker login -u olumayor99 -p 1987161255

docker push olumayor99/sre-frontend
docker push olumayor99/sre-backend

helm repo update