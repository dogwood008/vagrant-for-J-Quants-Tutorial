FROM continuumio/anaconda3:2019.03
LABEL mainteiner="dogwood008"

ENV PYTHONPATH=/opt/ml/src

RUN \
    # https://japanexchangegroup.github.io/J-Quants-Tutorial/#_%E5%BF%85%E8%A6%81%E3%81%AA%E3%83%A9%E3%82%A4%E3%83%96%E3%83%A9%E3%83%AA%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB
    # :shap用にg++とgccをインストールします
    apt update && \
      apt install -y --no-install-recommends g++ gcc && \
      # 必要なライブラリをインストールします
      pip install shap==0.37.0 slicer==0.0.3 xgboost==1.3.0.post0

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--no-browser", \
 "--no-mathjax", "--NotebookApp.disable_check_xsrf=True", \
 "--NotebookApp.token=''", "--NotebookApp.password=''", \
 "/notebook"]
