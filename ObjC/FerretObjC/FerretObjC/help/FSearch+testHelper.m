//
//  FSearch+testHelper.m
//  FerretObjC
//
//  Created by Andrew(Zhiyong) Yang on 1/14/16.
//  Copyright © 2016 FoolDragon. All rights reserved.
//

#import "FSearch+testHelper.h"
#include "index.h"
#include "search.h"
#include "internal.h"
#include "global.h"

char *field = "text";
IndexReader *ir;
Searcher *searcher;

@implementation FSearch (testHelper)

void create_index(Store *store, Config config)
{
    int i;
    IndexWriter *iw;
    Analyzer *a = whitespace_analyzer_new(true);
    FieldInfos *fis = fis_new(STORE_NO, INDEX_UNTOKENIZED, TERM_VECTOR_NO);
    char data[1000];
    Document *doc;
    index_create(store, fis);
    fis_deref(fis);
    
    iw = iw_open(store, a, &config);
    
    
    //config.merge_factor = 10;
    //config.min_merge_docs = 1000;
    
    for (i = 0; i < 99999; i++) {
        if (i%10000 == 0) printf("up to %d\n", i);
        doc = doc_new();
        sprintf(data, "<%d>", rand() % 1000000);
        doc_add_field(doc, df_add_data(df_new("num"), data));
        iw_add_doc(iw, doc);
        doc_destroy(doc);
    }
    //iw_optimize(iw);
    iw_close(iw);
}

void test_search2(char *q_str, int slop)
{

    
   
    
    char *t;
    Query *q = make_phrase_query(t=estrdup(q_str), slop); free(t);
    Document *doc;
    int i;
    //t = q->to_s(q, field);
    TopDocs *top_docs = searcher_search(searcher, q, 0, 4000, NULL, NULL, NULL);
    //printf("Running Query: <%s> hits = %ld\n", t, top_docs->size); free(t);
    
    for (i = 0; i < top_docs->size; i++) {
        Hit *hit = top_docs->hits[i];
        doc = ir->get_doc(ir, hit->doc);
        //printf("%d:%s with score of %f\n", hit->doc, doc_get_field(doc, "name")->data, hit->score);
        doc_destroy(doc);
    }
    td_destroy(top_docs);
    q_deref(q);
}

+ (void) testInFolder:(NSString*)folder {
    Store *store = open_fs_store("./index_folder");
    
    Config config = default_config;
    config.max_field_length = 0x7FFFFFFF;
    config.max_buffer_memory = 0x40000000;
    config.chunk_size = 0x8000000;
    config.max_buffered_docs = 1000;
    config.merge_factor = 11;
    
    init(0, NULL);
    create_index(store, config);
    
    
    ir = ir_open(store);
    searcher = isea_new(ir);
    
    for (int i = 0; i < 1000; i++) {
        test_search2("less than", 0);
        test_search2("such as", 0);
        test_search2("set of", 4);
        test_search2("when you need to", 0);
        test_search2("sometime in the future", 0);
        test_search2("the problem with", 4);
        test_search2("having said that", 0);
        test_search2("the need for", 0);
        test_search2("it is a", 0);
        test_search2("the first thing", 0);
        test_search2("come to think of it", 0);
        test_search2("finding the answer", 0);
        test_search2("who knows", 0);
        test_search2("not me", 0);
        test_search2("at the end of", 0);
        test_search2("what does", 4);
        test_search2("some things never", 0);
        test_search2("that is what you", 0);
        test_search2("this is for you", 4);
        test_search2("making the connection", 0);
        test_search2("not write it", 0);
        test_search2("you will probably find", 0);
        test_search2("you will need to", 4);
        test_search2("using the python binary", 0);
        test_search2("let me make it", 0);
        test_search2("if you don't", 4);
        test_search2("install the driver", 0);
        test_search2("unable to", 0);
        test_search2("there are a lot", 0);
        test_search2("the principle is", 4);
        test_search2("when you are young", 0);
        test_search2("do not have", 0);
        test_search2("there would be", 0);
    }
}
Query *make_phrase_query(char *qstr, int slop)
{
    char *terms[10], *p = qstr;
    int term_count = 0;
    bool in_term = false;
    
    while (*p) {
        if (isspace(*p)) {
            if (in_term) {
                in_term = false;
                term_count++;
                *p = 0;
            }
            p++;
            continue;
        }
        if (!in_term) {
            in_term = true;
            terms[term_count] = p;
        }
        p++;
    }
    if (in_term) {
        term_count++;
    }
    if (term_count == 1) {
        return tq_new(field, terms[0]);
    } else {
        int i;
        Query *phq = phq_new(field);
        for (i = 0; i < term_count; i++) {
            phq_add_term(phq, terms[i], 1);
        }
        ((PhraseQuery *)phq)->slop = slop;
        return phq;
    }
}
@end
