#!/usr/bin/env python

from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

import glob
import multiprocessing
import os.path
import sys

import numpy
import pandas
import scipy.stats
import sklearn.linear_model
import sklearn.ensemble


def pred_reg(reg,train_file,train,test):
    reg.fit(train.loc[:, 1:].values, train.loc[:, 0].values)
    pred = reg.predict(test.loc[:, 1:].values)
    testref_file = train_file.replace('train', 'testref')
    testref = pandas.read_table(testref_file, sep='\s+', header=None, usecols=[0])
    return scipy.stats.spearmanr(pred, testref.values)[0]


def pred(train_file):
    test_file = train_file.replace('train', 'test')
    train = pandas.read_table(train_file, sep='\s+', header=None)
    for j in range(1, len(train.columns)):
        split_col = train.iloc[:, j].str.split(':', expand=True)
        train.iloc[:, j] = split_col[1].astype(float)
    test = pandas.read_table(test_file, sep='\s+', header=None)
    for j in range(1, len(test.columns)):
        split_col = test.iloc[:, j].str.split(':', expand=True)
        test.iloc[:, j] = split_col[1].astype(float)
    reg_lr = sklearn.linear_model.LinearRegression()
    reg_ridge = sklearn.linear_model.RidgeCV()
    reg_lasso = sklearn.linear_model.LassoCV()
    reg_el = sklearn.linear_model.ElasticNetCV(numpy.arange(0.0, 1.1, 0.1))
    reg_rf = sklearn.ensemble.RandomForestRegressor(100)
    reg_gb = sklearn.ensemble.GradientBoostingRegressor('ls', 0.05, 300)
    
    cor_lr = pred_reg(reg_lr,train_file,train,test)
    cor_ridge = pred_reg(reg_ridge,train_file,train,test)
    cor_lasso = pred_reg(reg_lasso,train_file,train,test)
    cor_el = pred_reg(reg_el,train_file,train,test)
    cor_rf = pred_reg(reg_rf,train_file,train,test)
    cor_gb = pred_reg(reg_gb,train_file,train,test)
    
    return [cor_lr, cor_ridge, cor_lasso, cor_el, cor_rf, cor_gb]


def main():
    __, svm_dir, out_name = sys.argv 
    # input argumatns: dir of svm input files (containing .trian. files), output name
    
    pool = multiprocessing.Pool(8)
    with open(out_name, 'w') as f:
        train_files = glob.glob(os.path.join(svm_dir, '*train*'))
        result = pool.map(pred, train_files)
        mean = numpy.asarray(result).mean(axis=0)
        print("lr", mean[0], sep='\t', file=f, flush=True)
        print("ridge", mean[1], sep='\t', file=f, flush=True)
        print("lasso", mean[2], sep='\t', file=f, flush=True)
        print("el", mean[3], sep='\t', file=f, flush=True)
        print("rf", mean[4], sep='\t', file=f, flush=True)
        print("gb", mean[5], sep='\t', file=f, flush=True)
    pool.close()
    pool.join()


if __name__ == '__main__':
    sys.exit(main())
