FROM nginx:latest
# 템플릿 폴더를 Nginx의 기본 HTML 폴더로 복사
COPY ./my_template /usr/share/nginx/html